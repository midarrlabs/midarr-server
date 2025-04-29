defmodule MediaServer.SeriesIndex do
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

  def search(id) do
    Enum.filter(all(), fn item -> item["id"] == id end)
  end

  def get(url) do
    HTTPoison.get("#{System.get_env("SONARR_BASE_URL")}/api/v3/#{url}", %{
      "X-Api-Key" => System.get_env("SONARR_API_KEY")
    })
    |> handle_response()
  end

  def handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    case Jason.decode(body) do
      {:ok, decoded} ->
        decoded
      _ ->
        body
    end
  end

  def handle_response(_) do
    []
  end

  def get_all() do
    get("series?includeSeasonImages=true")
  end
end
