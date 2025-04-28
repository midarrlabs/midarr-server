defmodule MediaServer.AddMovies do
  use Oban.Worker, queue: :default, max_attempts: 3

  @impl true
  def perform(%Oban.Job{args: %{}}) do
    MediaServerWeb.Repositories.Movies.get_all()
    |> Enum.each(fn item ->
      MediaServer.Movies.insert(%{
        tmdb_id: item["tmdbId"],
        title: item["title"],
        overview: item["overview"],
        year: item["year"],
        poster: MediaServer.Helpers.get_poster(item),
        background: MediaServer.Helpers.get_background(item),
        path: item["movieFile"]["path"],
      })
    end)

    :ok
  end
end
