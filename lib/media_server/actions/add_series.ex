defmodule MediaServer.AddSeries do
  use Oban.Worker, queue: :default, max_attempts: 3

  @impl true
  @spec perform(%{:args => map(), optional(any()) => any()}) :: :ok
  def perform(%Oban.Job{args: %{"items" => items}}) do
    items
    |> Enum.each(fn item ->

      record = MediaServer.Series.insert(%{
        sonarr_id: item["sonarr_id"],
        tmdb_id: item["tmdb_id"],
        seasons: item["seasons"],
        title: item["title"],
        overview: item["overview"],
        poster: item["poster"],
        background: item["background"],
      })

      MediaServer.AddEpisode.new(%{"items" => MediaServerWeb.Repositories.Episodes.get_all(record.sonarr_id)
        |> Enum.map(fn item ->  %{
            series_id: record.id,
            sonarr_id: item["id"],
            season: item["seasonNumber"],
            number: item["episodeNumber"],
            title: item["title"],
            overview: item["overview"],
            screenshot: MediaServerWeb.Repositories.Episodes.get_screenshot(item),
          }
        end)})
        |> Oban.insert()
    end)

    :ok
  end
end
