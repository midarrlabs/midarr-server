defmodule MediaServer.SeriesActions do
  use GenServer

  require Logger

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Phoenix.PubSub.subscribe(MediaServer.PubSub, "series")

    {:ok, state}
  end

  def handle_info({:added}, state) do
    MediaServer.SeriesIndex.reset()

    {:noreply, state}
  end

  def handle_info({:deleted}, state) do
    MediaServer.SeriesIndex.reset()

    {:noreply, state}
  end

  def handle_info({:deleted_episode_file}, state) do
    MediaServer.SeriesIndex.reset()

    {:noreply, state}
  end
end