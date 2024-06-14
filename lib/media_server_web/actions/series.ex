defmodule MediaServerWeb.Actions.Series do
  require Logger

  def handle_info({:added, _params}) do
    MediaServer.SeriesIndex.reset()
  end

  def handle_info({:deleted}) do
    MediaServer.SeriesIndex.reset()
  end

  def handle_info({:deleted_episode_file}) do
    MediaServer.SeriesIndex.reset()
  end
end
