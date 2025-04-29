defmodule MediaServer.Workers.AddSeasons do
  use Oban.Worker, queue: :default, max_attempts: 3

  @impl true
  def perform(%Oban.Job{args: %{"id" => id, "sonarr_id" => sonarr_id}}) do
    MediaServer.SeriesIndex.find(MediaServer.SeriesIndex.all, sonarr_id)["seasons"]
    |> Enum.each(fn item ->
      MediaServer.Seasons.insert(%{
        series_id: id,
        number: item["seasonNumber"],
        poster: MediaServer.Helpers.get_poster(item),
      })
    end)

    :ok
  end
end
