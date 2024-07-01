defmodule MediaServer.AddEpisode do
  use Oban.Worker, queue: :default, max_attempts: 3

  @impl true
  @spec perform(%{:args => map(), optional(any()) => any()}) :: :ok
  def perform(%Oban.Job{args: %{"items" => items}}) do
    items
    |> Enum.each(fn item ->
      MediaServer.Episodes.insert(%{
        series_id: item["series_id"],
        sonarr_id: item["sonarr_id"],
        season: item["season"],
        number: item["number"],
        title: item["title"],
        overview: item["overview"],
        screenshot: item["screenshot"],
      })
    end)

    :ok
  end
end
