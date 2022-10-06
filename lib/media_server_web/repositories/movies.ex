defmodule MediaServerWeb.Repositories.Movies do
  def get_url(url) do
    "#{System.get_env("RADARR_BASE_URL")}/api/v3/#{url}?apiKey=#{System.get_env("RADARR_API_KEY")}"
  end

  def handle_response({:ok, %HTTPoison.Response{status_code: 200, body: []}}) do
    []
  end

  def handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    Jason.decode!(body)
  end

  def handle_response(_) do
    []
  end

  def get_all() do
    HTTPoison.get(get_url("movie"))
    |> handle_response()
    |> Enum.filter(fn item -> item["hasFile"] end)
    |> Enum.sort_by(& &1["title"], :asc)
  end

  def get_cast(id) do
    HTTPoison.get("#{get_url("credit")}&movieId=#{id}")
    |> handle_response()
    |> Stream.filter(fn item -> item["type"] === "cast" end)
  end

  def search(query) do
    HTTPoison.get("#{get_url("movie/lookup")}&term=#{URI.encode(query)}")
    |> handle_response()
    |> Stream.filter(fn item -> item["hasFile"] end)
    |> Enum.sort_by(& &1["title"], :asc)
  end
end
