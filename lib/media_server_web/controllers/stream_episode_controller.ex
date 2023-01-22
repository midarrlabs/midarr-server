defmodule MediaServerWeb.StreamEpisodeController do
  use MediaServerWeb, :controller

  plug MediaServerWeb.StreamVideo, "episode"

  def show(conn, _params) do
    conn
  end
end
