defmodule MediaServerWeb.SettingsLive.Index do
  use MediaServerWeb, :live_view

  alias MediaServer.Repo
  alias MediaServer.Accounts
  alias MediaServer.Accounts.User

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(:page_title, "Settings")
      |> assign(:current_user, Accounts.get_user_by_session_token(session["user_token"]))
    }
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {
      :noreply,
      socket
      |> assign(:users, Repo.all(User))
      |> assign(:user_name, User.name_changeset(socket.assigns.current_user))
      |> assign(:user, User.registration_changeset(%User{}, %{}))
    }
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.update_user_name(socket.assigns.current_user, user_params) do
      {:ok, _user} ->
        {
          :noreply,
          socket
          |> put_flash(:info, "Success")
          |> push_redirect(to: Routes.settings_index_path(socket, :index))
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :user_name, changeset)}
    end
  end

  def handle_event("invite", %{"user" => user_params}, socket) do
    case Accounts.register_user(%{
           "email" => user_params["email"],
           "name" => user_params["name"],
           "password" => "#{Enum.take_random(?a..?z, 12)}"
         }) do
      {:ok, user} ->
        Accounts.deliver_user_invitation_instructions(user, user_params["password"])

        {
          :noreply,
          socket
          |> put_flash(:info, "Success")
          |> push_redirect(to: Routes.settings_index_path(socket, :index))
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :user, changeset)}
    end
  end
end
