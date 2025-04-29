defmodule MediaServer.AddPeople do
  use Oban.Worker, queue: :default, max_attempts: 3

  @impl true
  def perform(%Oban.Job{args: %{"id" => id}}) do
    MediaServer.MoviesIndex.get_cast(id)
    |> Enum.each(fn item ->
      MediaServer.People.insert(%{
        tmdb_id: item["personTmdbId"],
        name: item["personName"],
        image: MediaServer.Helpers.get_headshot(item)
      })
    end)

    :ok
  end
end
