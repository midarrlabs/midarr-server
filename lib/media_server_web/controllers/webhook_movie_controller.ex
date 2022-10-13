defmodule MediaServerWeb.Webhooks.MovieController do
  use MediaServerWeb, :controller

  alias MediaServer.Indexers.Movie

  def create(conn, %{"eventType" => "Download"}) do

    Movie.reset()

    conn
    |> send_resp(201, "Ok")
  end

  def create(conn, _payload) do
    conn
    |> send_resp(200, "Ok")
  end
end
