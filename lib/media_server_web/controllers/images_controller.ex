defmodule MediaServerWeb.ImagesController do
  use MediaServerWeb, :controller

  def index(conn, %{"movie" => id, "type" => "poster"}) do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = MediaServerWeb.Repositories.Movies.get("mediacover/#{ id }/poster-500.jpg")

    conn
    |> put_resp_header("content-type", "image/image")
    |> put_resp_header("cache-control", "max-age=604800, public, must-revalidate")
    |> send_resp(200, body)
  end

  def index(conn, %{"movie" => id, "type" => "background", "size" => size}) do

    background_file = MediaServer.MoviesIndex.all()
                      |> MediaServer.MoviesIndex.find(id)
                      |> MediaServer.Helpers.get_background()
                      |> MediaServer.Helpers.get_image_file()

    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get("https://image.tmdb.org/t/p/#{ size }/#{ background_file }")

    conn
    |> put_resp_header("content-type", "image/image")
    |> put_resp_header("cache-control", "max-age=604800, public, must-revalidate")
    |> send_resp(200, body)
  end

  def index(conn, %{"movie" => id, "type" => "background"}) do

    background_file = MediaServer.MoviesIndex.all()
                      |> MediaServer.MoviesIndex.find(id)
                      |> MediaServer.Helpers.get_background()
                      |> MediaServer.Helpers.get_image_file()

    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get("https://image.tmdb.org/t/p/original/#{ background_file }")

    conn
    |> put_resp_header("content-type", "image/image")
    |> put_resp_header("cache-control", "max-age=604800, public, must-revalidate")
    |> send_resp(200, body)
  end

  def index(conn, %{"series" => id, "type" => "poster"}) do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get(MediaServerWeb.Repositories.Series.get_url("mediacover/#{ id }/poster-500.jpg"))

    conn
    |> put_resp_header("content-type", "image/image")
    |> put_resp_header("cache-control", "max-age=604800, public, must-revalidate")
    |> send_resp(200, body)
  end

  def index(conn, %{"series" => id, "type" => "background"}) do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get(MediaServerWeb.Repositories.Series.get_url("mediacover/#{ id }/fanart.jpg"))

    conn
    |> put_resp_header("content-type", "image/image")
    |> put_resp_header("cache-control", "max-age=604800, public, must-revalidate")
    |> send_resp(200, body)
  end

  def index(conn, %{"episode" => id, "type" => "screenshot"}) do
    case MediaServerWeb.Repositories.Episodes.get_episode(id) do

      nil -> conn |> send_resp(404, "Not found")

      item -> {:ok, %HTTPoison.Response{status_code: 200, body: body}} = item |> MediaServerWeb.Repositories.Episodes.get_screenshot() |> HTTPoison.get()
        conn
        |> put_resp_header("content-type", "image/image")
        |> put_resp_header("cache-control", "max-age=604800, public, must-revalidate")
        |> send_resp(200, body)
    end
  end

  def index(conn, %{"episode" => id, "type" => "poster"}) do
    case MediaServerWeb.Repositories.Episodes.get_episode(id) do

      nil -> conn |> send_resp(404, "Not found")

      item -> {:ok, %HTTPoison.Response{status_code: 200, body: body}} = item |> MediaServerWeb.Repositories.Episodes.get_poster() |> HTTPoison.get()
        conn
        |> put_resp_header("content-type", "image/image")
        |> put_resp_header("cache-control", "max-age=604800, public, must-revalidate")
        |> send_resp(200, body)
    end
  end
end
