defmodule MediaServerWeb.PageController do
  use MediaServerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, %{"id" => id}) do
    conn
    |> assign(:id, id)
    |> render("show.html")
  end
end
