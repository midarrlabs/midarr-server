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
        |> Repo.preload(:user_continues)
      )
    }
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {
      :noreply,
      socket
      |> assign(:user_continues, socket.assigns.current_user.user_continues)
    }
  end
end
