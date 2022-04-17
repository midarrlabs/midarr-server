defmodule MediaServerWeb.Plugs.VerifyToken do
  import Plug.Conn

  def init(default), do: default

  def call(%Plug.Conn{params: %{"token" => token}} = conn, _default) do
    case Phoenix.Token.verify(conn, "user auth", token, max_age: 86400) do
      {:ok, _user_id} -> conn

      {:error, :invalid} -> conn |> halt()
    end
  end
end