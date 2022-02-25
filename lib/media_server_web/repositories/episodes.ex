defmodule MediaServerWeb.Repositories.Episodes do

  def get_url(url) do
    "#{ Application.get_env(:media_server, :series_base_url) }/api/v3/#{ url }?apikey=#{ Application.get_env(:media_server, :series_api_key) }"
  end

  def get_all(series_id) do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get("#{ get_url("episode") }&seriesId=#{ series_id }")

    Enum.filter(Jason.decode!(body), fn x -> x["hasFile"] end) |> add_images_to_episodes()
  end

  def get_episode(id) do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get("#{ get_url("episode/#{ id }") }")

    Jason.decode!(body)
  end

  def get_episode_path(id) do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get("#{ get_url("episode/#{ id }") }")

    Jason.decode!(body)["episodeFile"]["path"]
  end

  def add_images_to_episodes(episodes) do
    Enum.map(episodes, fn episode ->
      Map.put(episode, "images", Map.get(get_episode(episode["id"]), "images"))
    end)
  end

  def get_poster(episode) do
    (Enum.filter(episode["series"]["images"], fn x -> x["coverType"] === "poster" end) |> Enum.at(0))["url"]
  end

  def get_background(episode) do
    (Enum.filter(episode["series"]["images"], fn x -> x["coverType"] === "fanart" end) |> Enum.at(0))["url"]
  end

  def get_screenshot(episode) do
    (Enum.filter(episode["images"], fn x -> x["coverType"] === "screenshot" end) |> Enum.at(0))["url"]
  end
end