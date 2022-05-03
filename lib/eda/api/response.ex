defmodule EDA.Api.HTTP do
  defstruct [:conn, :ref, :body]

  def build(conn, ref) do
    %__MODULE__{conn: conn, ref: ref}
  end
end
