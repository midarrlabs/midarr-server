defmodule MediaServer.Indexers.Movie do
  use Agent

  alias MediaServerWeb.Repositories.Movies

  def start_link(_opts) do
    Agent.start_link(fn -> Movies.get_all() end, name: __MODULE__)
  end

  def get_all() do
    Agent.get(__MODULE__, & &1)
  end

  def get_latest(amount) do
    Agent.get(__MODULE__, & &1)
    |> Enum.sort_by(& &1["movieFile"]["dateAdded"], :desc)
    |> Enum.filter(fn item -> item["hasFile"] end)
    |> Enum.take(amount)
  end

  def get_movie(id) do
    Agent.get(__MODULE__, & &1)
    |> Enum.find(fn item -> item["id"] === String.to_integer(id) end)
  end

  def get_movie_path(id) do
    movie = get_movie(id)

    movie["movieFile"]["path"]
  end
end
