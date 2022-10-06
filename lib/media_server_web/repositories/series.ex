defmodule MediaServerWeb.Repositories.Series do
  def get_url(url) do
    "#{System.get_env("SONARR_BASE_URL")}/api/v3/#{url}?apikey=#{System.get_env("SONARR_API_KEY")}"
  end

  def handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    Jason.decode!(body)
  end

  def handle_response(_) do
    []
  end

  def get_latest(amount) do
    HTTPoison.get(get_url("series"))
    |> handle_response()
    |> Enum.reverse()
    |> Stream.filter(fn item -> item["statistics"]["episodeFileCount"] !== 0 end)
    |> Stream.take(amount)
  end

  def get_all() do
    HTTPoison.get(get_url("series"))
    |> handle_response()
    |> Stream.filter(fn item -> item["statistics"]["episodeFileCount"] !== 0 end)
    |> Enum.sort_by(& &1["title"], :asc)
  end

  def get_serie(id) do
    HTTPoison.get(get_url("series/#{id}"))
    |> handle_response()
  end

  def get_poster(serie) do
    (Stream.filter(serie["images"], fn item -> item["coverType"] === "poster" end)
     |> Enum.at(0))["remoteUrl"]
  end

  def get_background(serie) do
    (Stream.filter(serie["images"], fn item -> item["coverType"] === "fanart" end)
     |> Enum.at(0))["remoteUrl"]
  end

  def search(query) do
    HTTPoison.get("#{get_url("series/lookup")}&term=#{URI.encode(query)}")
    |> handle_response()
    |> Stream.filter(fn item -> item["seasonFolder"] end)
    |> Enum.sort_by(& &1["title"], :asc)
  end
end
