defmodule MediaServer.AddSeries do
  use Oban.Worker, queue: :default, max_attempts: 3

  @impl true
  def perform(%Oban.Job{args: %{}}) do
    MediaServer.SeriesIndex.get_all()
    |> Enum.each(fn item ->
      MediaServer.Series.insert(%{
        sonarr_id: item["id"],
        tmdb_id: item["tmdbId"],
        seasons: item["statistics"]["seasonCount"],
        title: item["title"],
        overview: item["overview"],
        year: item["year"],
        poster: MediaServer.Helpers.get_poster(item),
        background: MediaServer.Helpers.get_background(item)
      })
    end)

    :ok
  end
end
