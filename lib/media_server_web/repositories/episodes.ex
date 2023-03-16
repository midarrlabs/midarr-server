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

  def get_root_path() do
    "/series"
  end

  def get_full_path(episode) do
    Regex.split(~r|/|, Map.get(Map.get(episode, "episodeFile"), "path"))
  end

  def get_season_path(episode) do
    get_full_path(episode)
    |> Enum.at(2)
  end

  def get_folder_path(episode) do
    get_full_path(episode)
    |> Enum.at(3)
  end

  def get_file_path(episode) do
    get_full_path(episode)
    |> Enum.at(4)
  end

  def get_episode_path(id) do
    episode =
      HTTPoison.get("#{Series.get_url("episode/#{id}")}")
      |> Series.handle_response()

    "#{ get_root_path() }/#{ get_season_path(episode) }/#{ get_folder_path(episode) }/#{ get_file_path(episode) }"
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
      "#{ get_root_path() }/#{ get_season_path(episode) }/#{ get_folder_path(episode) }", get_file_path(episode)
    )
    |> Subtitles.handle_subtitle("#{ get_root_path() }/#{ get_season_path(episode) }/#{ get_folder_path(episode) }")
  end
end
