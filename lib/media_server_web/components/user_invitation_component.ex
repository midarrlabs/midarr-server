defmodule MediaServerWeb.Components.UserInvitationComponent do
  use MediaServerWeb, :live_component

  alias MediaServer.Accounts

  def handle_event("save", %{"email" => email, "name" => name}, socket) do
    create(socket, %{"user" => %{"email" => email, "name" => name, "password" => "#{ Enum.take_random(?a..?z, 12) }"}})
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
    end
  end
end