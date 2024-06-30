defmodule MediaServer.AddMovies do
  use Oban.Worker, queue: :default, max_attempts: 3

  @impl true
  @spec perform(%{:args => map(), optional(any()) => any()}) :: :ok
  def perform(%Oban.Job{args: %{"items" => items}}) do
    items
    |> Enum.each(fn item ->
      MediaServer.Movies.insert(%{
        radarr_id: item["radarr_id"],
        tmdb_id: item["tmdb_id"],
        title: item["title"],
        overview: item["overview"],
        poster: item["poster"],
        background: item["background"]
      })
    end)

    :ok
  end
end
