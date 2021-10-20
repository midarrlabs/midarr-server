defmodule MediaServerWeb.PageController do
  use MediaServerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
