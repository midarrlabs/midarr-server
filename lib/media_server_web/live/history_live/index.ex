defmodule MediaServerWeb.HistoryLive.Index do
  use MediaServerWeb, :live_view

  import Ecto.Query

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(:current_user, MediaServer.Accounts.get_user_by_session_token(session["user_token"]))
      |> assign(page_title: "History")
    }
  end

  @impl true
  def handle_params(_params, _url, socket) do
    query =
      from ma in MediaServer.MediaActions,
           join: continue in MediaServer.Continues, on: ma.media_id == continue.media_id,
           where: continue.user_id == ^socket.assigns.current_user.id,
           order_by: [desc: ma.updated_at],
           limit: 12,
           preload: [continue: continue]

    current_user =
      socket.assigns.current_user
      |> MediaServer.Repo.preload([media_actions: query])

    {
      :noreply,
      socket
      |> assign(:movie_id, MediaServer.MediaTypes.get_movie_id())
      |> assign(:user_media_actions, current_user.media_actions)
    }
  end
end
