defmodule MediaServerWeb.Repositories.Episodes do

  def get_all(series_id, season_number) do
    MediaServerWeb.Repositories.Series.get("episode?seriesId=#{series_id}&seasonNumber=#{season_number}&includeImages=true")
  end

  def get_all(series_id) do
    MediaServerWeb.Repositories.Series.get("episode?seriesId=#{series_id}&includeImages=true")
  end

  def get_episode(id) do
    MediaServerWeb.Repositories.Series.get("episode/#{id}")
  end

  def get_episode_path(id) do
    episode = MediaServerWeb.Repositories.Series.get("episode/#{id}")

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
end
