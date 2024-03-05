defmodule MediaServer.MoviesIndex do
  def all() do
    GenStage.call(MediaServer.MovieConsumer, {:all})
  end

  def latest(state) do
    state
    |> Enum.sort_by(& &1.date_added, :desc)
  end

  def available(state) do
    state
    |> Enum.filter(fn item -> item.has_file end)
  end

  def upcoming(state) do
    state
    |> Enum.filter(fn item -> item.monitored end)
  end

  def take(state, amount) do
    state
    |> Enum.take(amount)
  end

  def genres(state) do
    state
    |> Enum.flat_map(fn x -> x.genres end)
    |> Enum.uniq()
  end

  def genre(state, genre) do
    state
    |> Enum.filter(fn item -> Enum.member?(item.genres, genre) end)
  end

  def find(id) do
    GenStage.call(MediaServer.MovieConsumer, {:all})
    |> Enum.find(fn item ->
      if !is_integer(id) do
        item.id === String.to_integer(id)
      else
        item.id === id
      end
    end)
  end

  def related(id) do
    genre = Enum.take(find(id).genres, 1) |> List.first()

    GenStage.call(MediaServer.MovieConsumer, {:all})
    |> Enum.filter(fn item -> genre in item.genres end)
    |> Enum.take_random(6)
    |> Enum.reject(fn x -> x.id == id end)
  end

  def search(query) do
    GenStage.call(MediaServer.MovieConsumer, {:all})
    |> Enum.filter(fn item -> String.contains?(String.downcase(item.title), String.downcase(query)) end)
  end
end
