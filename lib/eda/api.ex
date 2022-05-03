defmodule EDA.Api do
  alias EDA.Api.Base

  def gateway_bot(conn) do
    Base.request(conn, "GET", "/gateway/bot", [], nil)
  end
end
