defmodule MediaServerWeb.RoomChannel do
  use MediaServerWeb, :channel

  alias MediaServerWeb.Presence

  @impl true
  def join("room:lobby", %{"user_id" => user_id, "user_name" => user_name, "user_agent" => user_agent}, socket) do
    send(self(), :after_join)

    parsed_user_agent =  UAInspector.parse(user_agent)

    {:ok, assign(socket, %{user_id: user_id, user_name: user_name, user_agent: "#{ parsed_user_agent.client.name } for #{ parsed_user_agent.os.name }"})}
  end

  @impl true
  def handle_info(:after_join, socket) do
    {:ok, _} =
      Presence.track(socket, socket.assigns.user_id, %{
        online_at: inspect(System.system_time(:second)),
        user_id: socket.assigns.user_id,
        user_name: socket.assigns.user_name,
        user_agent: socket.assigns.user_agent,
      })

    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end
end
