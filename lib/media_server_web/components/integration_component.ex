defmodule MediaServerWeb.Components.IntegrationComponent do
  use MediaServerWeb, :live_component

  alias MediaServer.Integrations

  def handle_event("save", %{"radarr" => radarr_params}, socket) do
    save_radarr(socket, radarr_params)
  end

  def handle_event("save", %{"sonarr" => sonarr_params}, socket) do
    save_sonarr(socket, sonarr_params)
  end

  defp save_radarr(socket, radarr_params) do
    case Integrations.update_or_create_radarr(radarr_params) do
      {:ok, _radarr} ->
        {:noreply,
          socket
          |> put_flash(:info, "Success")
          |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_sonarr(socket, sonarr_params) do
    case Integrations.update_or_create_sonarr(sonarr_params) do
      {:ok, _sonarr} ->
        {:noreply,
          socket
          |> put_flash(:info, "Success")
          |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end