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

  def get_all() do
    HTTPoison.get(get_url("series"))
    |> handle_response()
    |> Stream.filter(fn item -> item["statistics"]["episodeFileCount"] !== 0 end)
    |> Enum.sort_by(& &1["title"], :asc)
  end

  def search(query) do
    HTTPoison.get("#{get_url("series/lookup")}&term=#{URI.encode(query)}")
    |> handle_response()
    |> Stream.filter(fn item -> item["seasonFolder"] end)
    |> Enum.sort_by(& &1["title"], :asc)
  end
end
