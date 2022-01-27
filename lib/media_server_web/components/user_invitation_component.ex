defmodule MediaServerWeb.Components.UserInvitationComponent do
  use MediaServerWeb, :live_component

  alias MediaServer.Accounts

  def handle_event("save", %{"user" => user_params}, socket) do
    create(socket, %{"user" => %{"email" => user_params["email"], "name" => user_params["name"], "password" => "#{ Enum.take_random(?a..?z, 12) }"}})
  end

  def create(socket, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        Accounts.deliver_user_invitation_instructions(user, user_params["password"])
        {
          :noreply,
          socket
          |> put_flash(:info, "Success")
          |> push_redirect(to: socket.assigns.return_to)
        }
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end