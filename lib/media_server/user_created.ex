defmodule MediaServer.UserCreated do
  use GenServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Phoenix.PubSub.subscribe(MediaServer.PubSub, "user")

    {:ok, state}
  end

  def handle_info({:registered, user}, state) do

    {:noreply, state}
  end
end