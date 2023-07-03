defmodule MediaServerWeb.HistoryLive.Index do
  use MediaServerWeb, :live_view

  import Ecto.Query

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(page_title: "History")
      |> assign(:current_user, MediaServer.Accounts.get_user_by_session_token(session["user_token"]))
    }
  end

  @impl true
  def handle_params(_params, _url, socket) do
    query = from continue in MediaServer.Continues, where: continue.user_id == ^socket.assigns.current_user.id

    current_user = socket.assigns.current_user |> MediaServer.Repo.preload(media_actions: from(MediaServer.MediaActions, order_by: [desc: :updated_at], preload: [continue: ^query]))
    {
      :noreply,
      socket
      |> assign(:movie_id, MediaServer.MediaTypes.get_movie_id())
      |> assign(:user_media_actions, current_user.media_actions)
    }
  end
end
