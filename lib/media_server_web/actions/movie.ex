defmodule MediaServerWeb.Actions.Movie do
  require Logger

  def handle_info({:added, _params}) do
    MediaServer.MoviesIndex.reset()
  end

  def handle_info({:deleted}) do
    MediaServer.MoviesIndex.reset()
  end

  def handle_info({:deleted_file}) do
    MediaServer.MoviesIndex.reset()
  end
end
