defmodule MediaServerWeb.Components.SubscribeComponent do
  use MediaServerWeb, :live_component

  @impl true
  def handle_event("subscribe", _unsigned_params, socket) do
    Phoenix.PubSub.broadcast(MediaServer.PubSub, "user", {:subscribed, %{}})

    {:noreply, socket}
  end
end
