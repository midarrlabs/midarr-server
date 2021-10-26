defmodule MediaServerWeb.LibraryLive.FormComponent do
  use MediaServerWeb, :live_component

  alias MediaServer.Libraries

  @impl true
  def update(%{library: library} = assigns, socket) do
    changeset = Libraries.change_library(library)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"library" => library_params}, socket) do
    changeset =
      socket.assigns.library
      |> Libraries.change_library(library_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"library" => library_params}, socket) do
    save_library(socket, socket.assigns.action, library_params)
  end

  defp save_library(socket, :edit, library_params) do
    case Libraries.update_library(socket.assigns.library, library_params) do
      {:ok, _library} ->
        {:noreply,
         socket
         |> put_flash(:info, "Library updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_library(socket, :new, library_params) do
    case Libraries.create_library(library_params) do
      {:ok, _library} ->
        {:noreply,
         socket
         |> put_flash(:info, "Library created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
