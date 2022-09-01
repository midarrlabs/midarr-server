defmodule MediaServerWeb.Repositories.Episodes do
  def get_url(url) do
    "#{Application.get_env(:media_server, :series_base_url)}/api/v3/#{url}?apikey=#{Application.get_env(:media_server, :series_api_key)}"
  end

  def handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    Jason.decode!(body)
  end

  def get_all(series_id, season_number) do
    HTTPoison.get("#{get_url("episode")}&seriesId=#{series_id}")
    |> handle_response()
    |> Stream.filter(fn episode ->
      episode["seasonNumber"] === String.to_integer(season_number)
    end)
    |> Stream.filter(fn episode -> episode["hasFile"] end)
    |> replace_each_with_episode_show_response()
  end

  def get_episode(id) do
    HTTPoison.get("#{get_url("episode/#{id}")}")
    |> handle_response()
  end

  def get_episode_path(id) do
    episode =
      HTTPoison.get("#{get_url("episode/#{id}")}")
      |> handle_response()

    episode["episodeFile"]["path"]
  end

  def replace_each_with_episode_show_response(episodes) do
    Enum.map(episodes, fn episode ->
      get_episode(episode["id"])
    end)
  end

  def get_background(episode) do
    (Stream.filter(episode["series"]["images"], fn x -> x["coverType"] === "fanart" end)
     |> Enum.at(0))["url"]
  end

  def get_screenshot(episode) do
    (Stream.filter(episode["images"], fn x -> x["coverType"] === "screenshot" end)
     |> Enum.at(0))["url"]
  end

  def handle_subtitle(nil, _parent_folder) do
    nil
  end

  def handle_subtitle(subtitle, parent_folder) do
    "#{parent_folder}/#{subtitle}"
  end

  def get_subtitle_path_for(id) do
    episode = get_episode(id)

    MediaServerWeb.Helpers.get_subtitle(
      MediaServerWeb.Helpers.get_parent_path(episode["episodeFile"]["path"]),
      MediaServerWeb.Helpers.get_file_name(episode["episodeFile"]["relativePath"])
    )
    |> handle_subtitle(MediaServerWeb.Helpers.get_parent_path(episode["episodeFile"]["path"]))
  end
end
