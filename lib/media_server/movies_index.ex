defmodule MediaServer.MoviesIndex do
  use Agent

  alias MediaServerWeb.Repositories.Movies

  def start_link(_opts) do
    Agent.start_link(fn -> Movies.get_all() end, name: __MODULE__)
  end

  def reset() do
    Agent.cast(__MODULE__, fn _state -> Movies.get_all() end)
  end

  def all() do
    Agent.get(__MODULE__, & &1)
  end

  def search(query) do
    Enum.filter(all(), fn item ->
      String.contains?(String.downcase(item["title"]), String.downcase(query))
    end)
  end
end
