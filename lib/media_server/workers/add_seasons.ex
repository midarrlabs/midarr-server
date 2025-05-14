defmodule MediaServer.Workers.AddSeasons do
  use Oban.Worker, queue: :default, max_attempts: 3

  @impl true
  def perform(%Oban.Job{args: %{"id" => id, "sonarr_id" => sonarr_id}}) do
    [series | _] = MediaServer.SeriesIndex.search(sonarr_id)

    Enum.each(series["seasons"], fn item ->
      MediaServer.Seasons.insert(%{
        series_id: id,
        number: item["seasonNumber"],
        poster: MediaServer.Helpers.get_poster(item),
      })
    end)

    :ok
  end
end
