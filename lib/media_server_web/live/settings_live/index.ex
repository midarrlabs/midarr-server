defmodule MediaServerWeb.SettingsLive.Index do
  use MediaServerWeb, :live_view

  alias MediaServer.Repo
  alias MediaServer.Accounts
  alias MediaServer.Accounts.User

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket |> assign(:current_user, Accounts.get_user_by_session_token(session["user_token"]))
    }
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {
      :noreply,
      socket
      |> assign(:page_title, "Settings")
      |> assign(:users, Repo.all(User))
      |> assign(:user_name, User.name_changeset(socket.assigns.current_user))
      |> assign(:user, User.registration_changeset(%User{}, %{}))
    }
  end
end
