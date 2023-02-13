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
    |> Enum.find(fn item ->
      if String.valid?(id) do
        item["id"] === String.to_integer(id)
      else
        item["id"] === id
      end
    end)
  end

  def get_root_path() do
    "/movies"
  end

  def get_full_path(movie) do
    Regex.split(~r|/|, Map.get(Map.get(movie, "movieFile"), "path"))
  end

  def get_folder_path(movie) do
    get_full_path(movie)
    |> Enum.at(2)
  end
  
  def get_file_path(movie) do
    get_full_path(movie)
    |> Enum.at(3)
  end

  def get_movie_path(id) do
    movie = get_movie(id)

    "#{ get_root_path() }/#{ get_folder_path(movie) }/#{ get_file_path(movie) }"
  end

  def get_movie_title(id) do
    movie =
      get_all()
      |> Enum.find(fn item -> item["id"] === id end)

    movie["title"]
  end

  def get_poster(movie) do
    MediaServer.Helpers.get_poster(movie)
  end

  def get_background(movie) do
    MediaServer.Helpers.get_background(movie)
  end

  def get_headshot(movie) do
    MediaServer.Helpers.get_headshot(movie)
  end
end
