defmodule MediaServerWeb.PageController do
  use MediaServerWeb, :controller

  def index(conn, _params) do
    conn
    |> assign(:movies, Kernel.elem(File.ls("/movies"), 1))
    |> render("index.html")
  end

  def show(conn, %{"id" => id}) do
    conn
    |> assign(:id, id)
    |> assign(:movies, Enum.filter(Kernel.elem(File.ls("/movies/" <> URI.decode(id)), 1), fn e -> String.contains? e, ".mp4" end))
    |> render("show.html")
  end
end
