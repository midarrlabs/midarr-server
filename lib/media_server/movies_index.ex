defmodule MediaServer.MoviesIndex do
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> get_all() end, name: __MODULE__)
  end

  def reset() do
    Agent.cast(__MODULE__, fn _state -> get_all() end)
  end

  def all() do
    Agent.get(__MODULE__, & &1)
  end

  def search(query) do
    Enum.filter(all(), fn item ->
      String.contains?(String.downcase(item["title"]), String.downcase(query))
    end)
  end

  def get(url) do
    HTTPoison.get("#{System.get_env("RADARR_BASE_URL")}/api/v3/#{url}", %{
      "X-Api-Key" => System.get_env("RADARR_API_KEY")
    })
  end

  def handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    Jason.decode!(body)
  end

  def handle_response(_) do
    []
  end

  def get_all() do
    get("movie")
    |> handle_response()
  end

  def get_cast(id) do
    get("credit?movieId=#{id}")
    |> handle_response()
    |> Stream.filter(fn item -> item["type"] === "cast" end)
  end
end
