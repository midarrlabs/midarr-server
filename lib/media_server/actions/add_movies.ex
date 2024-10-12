defmodule MediaServer.AddMovies do
  use Oban.Worker, queue: :default, max_attempts: 3

  @impl true
  @spec perform(%{:args => map(), optional(any()) => any()}) :: :ok
  def perform(%Oban.Job{args: %{"items" => items}}) do
    items
    |> Enum.each(fn item ->

      record = MediaServer.Movies.insert(%{
        radarr_id: item["radarr_id"],
        tmdb_id: item["tmdb_id"],
        title: item["title"],
        overview: item["overview"],
        poster: item["poster"],
        background: item["background"]
      })

      MediaServer.AddPeople.new(%{"items" => MediaServerWeb.Repositories.Movies.get_cast(record.radarr_id)
      |> Enum.map(fn item ->  %{
          tmdb_id: item["personTmdbId"],
          name: item["personName"],
          image: MediaServer.Helpers.get_headshot(item)
        }
      end)
      })
      |> Oban.insert()
    end)

    :ok
  end
end
