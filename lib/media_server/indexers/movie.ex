defmodule MediaServer.Indexers.Movie do
  use Agent

  alias MediaServerWeb.Repositories.Movies

  def start_link() do
    Agent.start_link(fn ->
      Movies.get_all()
    end)
  end

  def get_all(bucket) do
    Agent.get(bucket, fn state -> state end)
  end
end