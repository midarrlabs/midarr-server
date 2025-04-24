defmodule MediaServer.AddEpisodes do
  use Oban.Worker, queue: :default, max_attempts: 3

  @impl true
  def perform(%Oban.Job{args: %{"id" => id, "sonarr_id" => sonarr_id}}) do
    MediaServerWeb.Repositories.Episodes.get_all(sonarr_id)
    |> Enum.each(fn item ->
      MediaServer.Episodes.insert(%{
        series_id: id,
        sonarr_id: item["id"],
        season: item["seasonNumber"],
        number: item["episodeNumber"],
        title: item["title"],
        overview: item["overview"],
        screenshot: MediaServerWeb.Repositories.Episodes.get_screenshot(item)
      })
    end)

    :ok
  end
end
