defmodule MediaServerWeb.HistoryLive.Index do
  use MediaServerWeb, :live_view

  import Ecto.Query

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(
        :current_user,
        MediaServer.Accounts.get_user_by_session_token(session["user_token"])
      )
    }
  end

  @impl true
  def handle_params(_params, _url, socket) do
    query =
      from ma in MediaServer.MediaActions,
        where:
          ma.media_type_id == ^MediaServer.Types.get_movie_id() and
            ma.user_id == ^socket.assigns.current_user.id,
        order_by: [desc: ma.updated_at],
        limit: 10

    current_user = socket.assigns.current_user |> MediaServer.Repo.preload(media_actions: query)

    {
      :noreply,
      socket
      |> assign(page_title: "History")
      |> assign(:user_media_actions, current_user.media_actions)
    }
  end
end
