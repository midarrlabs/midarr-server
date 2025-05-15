defmodule MediaServerWeb.ImagesController do
  use MediaServerWeb, :controller

  def index(conn, %{"url" => url}) do

    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get(url)

    conn
    |> put_resp_header("content-type", "image/image")
    |> put_resp_header("cache-control", "max-age=604800, public, must-revalidate")
    |> send_resp(200, body)
  end
end
