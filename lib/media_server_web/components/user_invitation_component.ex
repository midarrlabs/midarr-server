defmodule MediaServerWeb.Components.UserInvitationComponent do
  use MediaServerWeb, :live_component

  alias MediaServer.Accounts

  def handle_event("save", %{"email" => email}, socket) do
    create(socket, %{"user" => %{"email" => email, "password" => Ecto.UUID.generate()}})
  end

  def create(socket, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(socket, :edit, &1)
          )
        {:noreply,
          socket
          |> put_flash(:info, "Success")
          |> push_redirect(to: socket.assigns.return_to)}
    end
  end
end