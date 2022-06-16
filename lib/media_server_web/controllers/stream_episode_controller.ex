defmodule MediaServerWeb.StreamEpisodeController do
  use MediaServerWeb, :controller

  alias MediaServerWeb.Repositories.Episodes
  alias MediaServerWeb.Helpers

  def show(%{req_headers: headers} = conn, %{"id" => id}) do
    Helpers.send_video(conn, headers, Episodes.get_episode_path(id))
  end
end
