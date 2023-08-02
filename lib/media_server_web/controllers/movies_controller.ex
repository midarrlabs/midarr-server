defmodule MediaServerWeb.MoviesController do
  use MediaServerWeb, :controller

  def index(conn, _params) do
    movies = Scrivener.paginate(MediaServer.MoviesIndex.all(), %{
      "page" => "1",
      "page_size" => "50"
    })

    conn
    |> send_resp(200, Jason.encode!(movies.entries))
  end
end
