defmodule MediaServer.EpisodesFixtures do

  def get_url(url) do
    "#{ Application.fetch_env!(:media_server, :series_base_url) }/api/v3/#{ url }?apiKey=#{ Application.fetch_env!(:media_server, :series_api_key) }"
  end

  def get_all(series_id) do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get("#{ get_url("episode") }&seriesId=#{ series_id }")

    Jason.decode!(body)
  end

  def get_episode(series_id) do
    get_all(series_id) |> List.first()
  end
end
