defmodule MediaServerWeb.SonarrLive.FormComponent do
  use MediaServerWeb, :live_component

  alias MediaServer.Integrations

  @impl true
  def update(%{sonarr: sonarr} = assigns, socket) do
    changeset = Integrations.change_sonarr(sonarr)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"sonarr" => sonarr_params}, socket) do
    changeset =
      socket.assigns.sonarr
      |> Integrations.change_sonarr(sonarr_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"sonarr" => sonarr_params}, socket) do
    save_sonarr(socket, socket.assigns.action, sonarr_params)
  end

  defp save_sonarr(socket, :edit, sonarr_params) do
    case Integrations.update_sonarr(socket.assigns.sonarr, sonarr_params) do
      {:ok, _sonarr} ->
        {:noreply,
         socket
         |> put_flash(:info, "Sonarr updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_sonarr(socket, :new, sonarr_params) do
    case Integrations.create_sonarr(sonarr_params) do
      {:ok, _sonarr} ->
        {:noreply,
         socket
         |> put_flash(:info, "Sonarr created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
