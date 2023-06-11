defmodule MediaServerWeb.HistoryLive.Index do
  use MediaServerWeb, :live_view

  import Ecto.Query

  alias MediaServer.Repo
  alias MediaServer.Accounts

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(page_title: "History")
      |> assign(
        :current_user,
        Accounts.get_user_by_session_token(session["user_token"])
        |> Repo.preload(media_actions: from(MediaServer.MediaActions, order_by: [desc: :updated_at]))
         )
    }
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {
      :noreply,
      socket
      |> assign(:movie_id, MediaServer.MediaTypes.get_movie_id())
      |> assign(:user_continues, socket.assigns.current_user.media_actions)
    }
  end
end
