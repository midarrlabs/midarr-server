defmodule MediaServer.Indexers.Movie do
  use Agent

  alias MediaServerWeb.Repositories.Movies

  def start_link(_opts) do
    Agent.start_link(fn -> Movies.get_all() end, name: __MODULE__)
  end

  def get_all() do
    Agent.get(__MODULE__, & &1)
  end
end