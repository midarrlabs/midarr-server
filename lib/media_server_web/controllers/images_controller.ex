defmodule MediaServerWeb.ImagesController do
  use MediaServerWeb, :controller

  def index(conn, %{"movie" => id, "type" => "poster"}) do

    poster_file = MediaServer.MoviesIndex.get_movie(id)
             |> MediaServer.MoviesIndex.get_poster()
             |> MediaServer.Helpers.get_poster_file()

    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get("https://image.tmdb.org/t/p/original/#{ poster_file }")

    conn
    |> put_resp_header("content-type", "image/image")
    |> send_resp(200, body)
  end
end
