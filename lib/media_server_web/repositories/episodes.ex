defmodule MediaServerWeb.Repositories.Episodes do
  alias MediaServerWeb.Repositories.Series
  alias MediaServer.Subtitles

  def get_all(series_id, season_number) do
    Series.get("episode?seriesId=#{series_id}&includeImages=true")
    |> Enum.filter(fn episode ->
      episode["seasonNumber"] === String.to_integer(season_number)
    end)
  end

  def get_all(series_id) do
    Series.get("episode?seriesId=#{series_id}")
  end

  def get_episode(id) do
    Series.get("episode/#{id}")
  end

  def get_episode_path(id) do
    episode = Series.get("episode/#{id}")

    episode["episodeFile"]["path"]
  end

  def handle_image(nil) do
    nil
  end

  def handle_image(screenshot) do
    screenshot["remoteUrl"]
  end

  def get_screenshot(episode) do
    Enum.find(episode["images"], nil, fn x -> x["coverType"] === "screenshot" end)
    |> handle_image()
  end

  def get_poster(episode) do
    Enum.find(episode["series"]["images"], nil, fn x -> x["coverType"] === "poster" end)
    |> handle_image()
  end

  def get_subtitle_path_for(id) do
    episode = get_episode(id)

    Subtitles.get_subtitle(
      Subtitles.get_parent_path(episode["episodeFile"]["path"]),
      Subtitles.get_file_name(episode["episodeFile"]["relativePath"])
    )
    |> Subtitles.handle_subtitle(Subtitles.get_parent_path(episode["episodeFile"]["path"]))
  end
end
