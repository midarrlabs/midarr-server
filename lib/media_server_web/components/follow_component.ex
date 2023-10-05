defmodule MediaServerWeb.Components.FollowComponent do
  use MediaServerWeb, :live_component

  @impl true
  def handle_event("follow", %{"media_id" => media_id}, socket) do
    Phoenix.PubSub.broadcast(MediaServer.PubSub, "user", {:followed, media_id})

    {:noreply, socket}
  end
end
