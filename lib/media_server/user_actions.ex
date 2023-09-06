defmodule MediaServer.UserActions do
  use GenServer

  require Logger

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Phoenix.PubSub.subscribe(MediaServer.PubSub, "user")

    {:ok, state}
  end

  def handle_info({:registered, _user}, state) do
    {:noreply, state}
  end

  def handle_info({:navigated, url}, state) do
    Logger.info(url)

    {:noreply, state}
  end
end
