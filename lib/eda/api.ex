defmodule EDA.Api do
  alias EDA.Api.Base

  def gateway(conn) do
    Base.request(conn, "GET", "/gateway", [])
  end

  def gateway_bot(conn) do
    Base.request(conn, "GET", "/gateway/bot", [])
  end
end
