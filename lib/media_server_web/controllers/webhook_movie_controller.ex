defmodule MediaServerWeb.Webhooks.MovieController do
  use MediaServerWeb, :controller

  alias MediaServer.Movies.Indexer

  def create(conn, %{"eventType" => "Download"}) do
    Indexer.reset()

    conn
    |> send_resp(201, "Ok")
  end

  def create(conn, _payload) do
    conn
    |> send_resp(200, "Ok")
  end
end