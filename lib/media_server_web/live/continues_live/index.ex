defmodule MediaServerWeb.ContinuesLive.Index do
  use MediaServerWeb, :live_view

  alias MediaServer.Repo
  alias MediaServer.Accounts

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(page_title: "Continues")
      |> assign(
        :current_user,
        Accounts.get_user_by_session_token(session["user_token"])
        |> Repo.preload(:movie_continues)
        |> Repo.preload(:episode_continues)
      )
    }
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {
      :noreply,
      socket
      |> assign(:movie_continues, socket.assigns.current_user.movie_continues)
      |> assign(:episode_continues, socket.assigns.current_user.episode_continues)
    }
  end
end
