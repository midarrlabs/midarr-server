defmodule MediaServerWeb.ImagesController do
  use MediaServerWeb, :controller

  def index(conn, %{"movie" => id, "type" => "poster"}) do

    poster_file = MediaServer.MoviesIndex.get_movie(id)
             |> MediaServer.MoviesIndex.get_poster()
             |> MediaServer.Helpers.get_image_file()

    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get("https://image.tmdb.org/t/p/w342/#{ poster_file }")

    conn
    |> put_resp_header("content-type", "image/image")
    |> send_resp(200, body)
  end

  def index(conn, %{"movie" => id, "type" => "background"}) do

    background_file = MediaServer.MoviesIndex.get_movie(id)
                  |> MediaServer.MoviesIndex.get_background()
                  |> MediaServer.Helpers.get_image_file()

    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get("https://image.tmdb.org/t/p/original/#{ background_file }")

    conn
    |> put_resp_header("content-type", "image/image")
    |> send_resp(200, body)
  end

  def index(conn, %{"series" => id, "type" => "poster"}) do

    poster_file = MediaServer.SeriesIndex.get_serie(id)
                  |> MediaServer.SeriesIndex.get_poster()
                  |> MediaServer.Helpers.get_image_file()

    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get("https://artworks.thetvdb.com/banners/posters/#{ poster_file }")

    conn
    |> put_resp_header("content-type", "image/image")
    |> send_resp(200, body)
  end
end
