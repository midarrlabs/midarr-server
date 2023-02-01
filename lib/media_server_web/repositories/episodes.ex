defmodule MediaServerWeb.Repositories.Episodes do
  alias MediaServerWeb.Repositories.Series
  alias MediaServer.Subtitles

  def get_all(series_id, season_number) do
    HTTPoison.get("#{Series.get_url("episode")}&seriesId=#{series_id}")
    |> Series.handle_response()
    |> Enum.filter(fn episode ->
      episode["seasonNumber"] === String.to_integer(season_number)
    end)
    |> replace_each_with_episode_show_response()
  end

  def get_episode(id) do
    HTTPoison.get("#{Series.get_url("episode/#{id}")}")
    |> Series.handle_response()
  end

  def get_episode_path(id) do
    episode =
      HTTPoison.get("#{Series.get_url("episode/#{id}")}")
      |> Series.handle_response()

    episode["episodeFile"]["path"]
  end

  def replace_each_with_episode_show_response(episodes) do
    Enum.map(episodes, fn episode ->
      get_episode(episode["id"])
    end)
  end

  def get_background(episode) do
    (Enum.filter(episode["series"]["images"], fn x -> x["coverType"] === "fanart" end)
     |> Enum.at(0))["url"]
  end

  def get_screenshot(episode) do
    (Enum.filter(episode["images"], fn x -> x["coverType"] === "screenshot" end)
     |> Enum.at(0))["url"]
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
