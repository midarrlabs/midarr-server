defmodule MediaServer.MoviesWebhook do
  use Agent

  alias MediaServerWeb.Repositories.Movies

  def start_link(_opts) do
    Agent.start_link(fn -> Movies.set_notification() end, name: __MODULE__)
  end
end