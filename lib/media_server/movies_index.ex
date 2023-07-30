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

  def latest(state) do
    state
    |> Enum.sort_by(& &1["movieFile"]["dateAdded"], :desc)
  end

  def take(state, amount) do
    state
    |> Enum.take(amount)
  end

  def genres(state) do
    state
    |> Enum.flat_map(fn x -> x["genres"] end)
    |> Enum.uniq()
  end

  def genre(state, genre) do
    state
    |> Enum.filter(fn item -> Enum.member?(item["genres"], genre) end)
  end

  def find(state, id) do
    state
    |> Enum.find(fn item ->
      if String.valid?(id) do
        item["id"] === String.to_integer(id)
      else
        item["id"] === id
      end
    end)
  end

  def related(state, id) do
    genre = Enum.take(find(state, id)["genres"], 1) |> List.first()

    state
    |> Enum.filter(fn item -> genre in item["genres"] end)
    |> Enum.take_random(20)
    |> Enum.reject(fn x -> x["id"] === id end)
  end

  def search(state, query) do
    Enum.filter(state, fn item ->
      String.contains?(String.downcase(item["title"]), String.downcase(query))
    end)
  end
end
