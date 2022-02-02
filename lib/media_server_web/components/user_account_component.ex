defmodule MediaServerWeb.Components.UserAccountComponent do
  use MediaServerWeb, :live_component

  alias MediaServer.Accounts

  def handle_event("save", %{"user" => user_params}, socket) do
    create(socket, %{"user" => %{"name" => user_params["name"]}})
  end

  def create(socket, %{"user" => user_params}) do
    case Accounts.update_user_name(socket.assigns.current_user, user_params) do
      {:ok, _user} ->
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