defmodule MediaServerWeb.PageController do
  use MediaServerWeb, :controller

  alias MediaServer.Media

  def index(conn, _params) do
    conn
    |> assign(:files, Media.list_files())
    |> render("index.html")
  end

  def show(conn, %{"id" => id}) do
    conn
    |> assign(:id, id)
    |> render("show.html")
  end
end
