defmodule EDA.Api.Base do
  @moduledoc false

  @token Application.get_env(:eda, :token)
  @lib_url EDA.MixProject.project()[:source_url]
  @lib_vsn EDA.MixProject.project()[:version]
  @endpoint "/api/v9"

  def connect() do
    Mint.HTTP.connect(:https, "discord.com", 443)
  end

  def request(conn, method, path, headers, body \\ nil)

  def request(conn, method, path, [], body) do
    {:ok, conn, ref} = Mint.HTTP.request(conn, method, @endpoint <> path, default_headers(), body)
    :ok = receive_next_and_stream(conn)
    response_waiting_loop(conn, ref)
  end

  def request(conn, method, path, headers, body) do
    {:ok, conn, ref} = Mint.HTTP.request(conn, method, @endpoint <> path, default_headers() ++ headers, body)
    :ok = receive_next_and_stream(conn)
    response_waiting_loop(conn, ref)
  end

  defp default_headers() do
    [
      {"Authorization", "Bot #{@token}"},
      {"User-Agent", "DiscordBot (#{@lib_url}, #{@lib_vsn})"}
    ]
  end

  defp receive_next_and_stream(conn) do
    receive do
      message ->
        case Mint.HTTP.stream(conn, message) do
          {:ok, conn, []} ->
            receive_next_and_stream(conn)

          {:ok, conn, responses} ->
            handle_responses(conn, responses)
        end
    end
  end

  defp handle_responses(conn, responses) do
    Enum.reduce(responses, fn response, _status ->
      case response do
        {_action, _ref, _data} ->
          handle_response(conn, response)
          :ok

        {:done, _ref} ->
          :ok
      end
    end)
  end

  defp handle_response(conn, {action, ref, data}) when action in [:headers, :status, :data] do
    send(self(), {action, conn, ref, data})
  end

  def response_waiting_loop(conn, ref) do
    receive do
      {:data, _conn, _ref, data} ->
        Jason.decode(data)

      _ ->
        response_waiting_loop(conn, ref)
    after
      10000 ->
        nil
    end
  end
end
