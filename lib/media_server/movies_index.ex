defmodule MediaServer.MoviesIndex do
  use Agent

  alias MediaServerWeb.Repositories.Movies

  def start_link(_opts) do
    Agent.start_link(fn -> Movies.get_all() end, name: __MODULE__)
  end

  def reset() do
    Agent.cast(__MODULE__, fn _state -> Movies.get_all() end)
  end

  def get_all() do
    Agent.get(__MODULE__, & &1)
  end

  def get_latest(amount) do
    get_all()
    |> Enum.sort_by(& &1["movieFile"]["dateAdded"], :desc)
    |> Enum.take(amount)
  end

  def get_movie(id) do
    get_all()
    |> Enum.find(fn item -> item["id"] === String.to_integer(id) end)
  end

  def get_movie_path(id) do
    movie = get_movie(id)

    movie["movieFile"]["path"]
  end

  def get_movie_title(id) do
    movie = get_all()
            |> Enum.find(fn item -> item["id"] === id end)

    movie["title"]
  end

  def some_value({:ok, value}) do
    value
  end

  def some_value({:error}) do
    ""
  end

  def another_test(nil) do
    ""
  end

  def another_test(value) do
    Map.fetch(value, "remoteUrl")
    |> some_value()
  end

  def some_test({:ok, value}, type) do
    Enum.find(value, fn item -> item["coverType"] === type end)
    |> another_test()
  end

  def some_test(:error, _type) do
    ""
  end

  def get_poster(movie) do
    Map.fetch(movie, "images")
    |> some_test("poster")
  end

  def get_background(movie) do
    (Enum.filter(movie["images"], fn item -> item["coverType"] === "fanart" end)
     |> Enum.at(0))["remoteUrl"]
  end

  def get_headshot(movie) do
    (Enum.filter(movie["images"], fn item -> item["coverType"] === "headshot" end)
     |> Enum.at(0))["url"]
  end
end
