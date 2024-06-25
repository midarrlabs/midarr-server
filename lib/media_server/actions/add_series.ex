defmodule MediaServer.AddSeries do
  use Oban.Worker, queue: :default, max_attempts: 3

  @impl true
  @spec perform(%{:args => map(), optional(any()) => any()}) :: :ok
  def perform(%Oban.Job{args: %{"items" => items}}) do
    items
    |> Enum.each(fn item ->
      MediaServer.Series.insert(%{
        sonarr_id: item["id"],
        tmdb_id: item["tmdbId"],
        seasons: item["statistics"]["seasonCount"],
        title: item["title"],
        overview: item["overview"],
        poster: MediaServer.Helpers.get_poster(item),
        background: MediaServer.Helpers.get_background(item),
      })
    end)

    :ok
  end
end
