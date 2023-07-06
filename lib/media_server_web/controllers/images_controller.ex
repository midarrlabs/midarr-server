defmodule MediaServerWeb.ImagesController do
  use MediaServerWeb, :controller

  def index(conn, %{"movie" => id, "type" => "poster"}) do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = MediaServerWeb.Repositories.Movies.get("mediacover/#{ id }/poster-500.jpg")

    conn
    |> put_resp_header("content-type", "image/image")
    |> send_resp(200, body)
  end

  def index(conn, %{"movie" => id, "type" => "background"}) do

    background_file = MediaServer.MoviesIndex.get_movie(id)
                      |> MediaServer.MoviesIndex.get_background()
                      |> MediaServer.Helpers.get_image_file()

    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get("https://image.tmdb.org/t/p/w1280/#{ background_file }")

    conn
    |> put_resp_header("content-type", "image/image")
    |> send_resp(200, body)
  end

  def index(conn, %{"series" => id, "type" => "poster"}) do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get(MediaServerWeb.Repositories.Series.get_url("mediacover/#{ id }/poster-500.jpg"))

    conn
    |> put_resp_header("content-type", "image/image")
    |> send_resp(200, body)
  end

  def index(conn, %{"series" => id, "type" => "background"}) do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get(MediaServerWeb.Repositories.Series.get_url("mediacover/#{ id }/fanart.jpg"))

    conn
    |> put_resp_header("content-type", "image/image")
    |> send_resp(200, body)
  end

  def index(conn, %{"episode" => id, "type" => "screenshot"}) do

    if MediaServerWeb.Repositories.Episodes.get_episode(id) |> MediaServerWeb.Repositories.Episodes.get_screenshot() do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} = MediaServerWeb.Repositories.Episodes.get_episode(id) |> MediaServerWeb.Repositories.Episodes.get_screenshot() |> HTTPoison.get()

      conn
      |> put_resp_header("content-type", "image/image")
      |> send_resp(200, body)
    else
      conn
      |> send_resp(404, "Not found")
    end
  end

  def index(conn, %{"episode" => id, "type" => "poster"}) do

    if MediaServerWeb.Repositories.Episodes.get_episode(id) |> MediaServerWeb.Repositories.Episodes.get_poster() do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} = MediaServerWeb.Repositories.Episodes.get_episode(id) |> MediaServerWeb.Repositories.Episodes.get_poster() |> HTTPoison.get()

      conn
      |> put_resp_header("content-type", "image/image")
      |> send_resp(200, body)
    else
      conn
      |> send_resp(404, "Not found")
    end
  end
end
