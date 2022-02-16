defmodule MediaServerWeb.Repositories.Series do

  def get_url(url) do
    "#{ Application.fetch_env!(:media_server, :series_base_url) }/api/v3/#{ url }?apikey=#{ Application.fetch_env!(:media_server, :series_api_key) }"
  end

  def get_latest(amount) do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get(get_url("series"))

    Enum.sort_by(Jason.decode!(body), &(&1["added"]), :desc)
    |> Enum.filter(fn x -> x["statistics"]["episodeFileCount"] !== 0 end)
    |> Enum.take(amount)
  end

  def get_all() do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get(get_url("series"))

    Enum.sort_by(Jason.decode!(body), &(&1["title"]), :asc)
    |> Enum.filter(fn x -> x["statistics"]["episodeFileCount"] !== 0 end)
  end

  def get_serie(id) do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get(get_url("series/#{ id }"))

    Jason.decode!(body)
  end
end