defmodule MediaServerWeb.RadarrLive.FormComponent do
  use MediaServerWeb, :live_component

  alias MediaServer.Providers

  @impl true
  def update(%{radarr: radarr} = assigns, socket) do
    changeset = Providers.change_radarr(radarr)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"radarr" => radarr_params}, socket) do
    changeset =
      socket.assigns.radarr
      |> Providers.change_radarr(radarr_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"radarr" => radarr_params}, socket) do
    save_radarr(socket, socket.assigns.action, radarr_params)
  end

  defp save_radarr(socket, :edit, radarr_params) do
    case Providers.update_radarr(socket.assigns.radarr, radarr_params) do
      {:ok, _radarr} ->
        {:noreply,
         socket
         |> put_flash(:info, "Radarr updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_radarr(socket, :new, radarr_params) do
    case Providers.create_radarr(radarr_params) do
      {:ok, _radarr} ->
        {:noreply,
         socket
         |> put_flash(:info, "Radarr created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
