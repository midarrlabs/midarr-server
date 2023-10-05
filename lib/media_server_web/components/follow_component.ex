defmodule MediaServerWeb.Components.FollowComponent do
  use MediaServerWeb, :live_component

  @impl true
  def handle_event("follow", params, socket) do
    Phoenix.PubSub.broadcast(MediaServer.PubSub, "user", {:followed, params})

    {:noreply, socket}
  end
end
