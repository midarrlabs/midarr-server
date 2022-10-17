defmodule MediaServerWeb.VerifyToken do
  import Plug.Conn

  def init(default), do: default

  def handle_response({:ok, _user_id}, conn) do
    conn
  end

  def handle_response({:error, :invalid}, conn) do
    conn
    |> resp(403, "Forbidden")
    |> halt
  end

  def handle_response({:error, :expired}, conn) do
    conn
    |> resp(403, "Forbidden")
    |> halt
  end

  def call(%Plug.Conn{params: %{"token" => token}} = conn, _default) do
    Phoenix.Token.verify(conn, "user auth", token, max_age: 86400)
    |> handle_response(conn)
  end

  def call(conn, _default) do
    conn
    |> resp(403, "Forbidden")
    |> halt
  end
end
