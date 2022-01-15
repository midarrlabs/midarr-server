defmodule MediaServerWeb.Components.UserComponent do
  use MediaServerWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, socket |> assign(show_users: false)}
  end

  @impl true
  def handle_event("open", _, socket) do
    {:noreply, socket |> assign(show_users: true)}
  end

  @impl true
  def handle_event("close", _, socket) do
    {:noreply, socket |> assign(show_users: false)}
  end
end