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

  def latest(state) do
    state
    |> Enum.sort_by(& &1["added"], :desc)
  end

  def available(state) do
    state
    |> Enum.filter(fn item -> item["statistics"]["episodeFileCount"] !== 0 end)
  end

  def upcoming(state) do
    state
    |> Enum.filter(fn item -> item["monitored"] end)
  end

  def take(state, amount) do
    state
    |> Enum.take(amount)
  end

  def genres(state) do
    state
    |> Enum.flat_map(fn x -> x["genres"] end)
    |> Enum.uniq()
  end

  def genre(state, genre) do
    state
    |> Enum.filter(fn item -> Enum.member?(item["genres"], genre) end)
  end

  def find(state, id) do
    state
    |> Enum.find(fn item ->
      if !is_integer(id) do
        item["id"] === String.to_integer(id)
      else
        item["id"] === id
      end
    end)
  end

  def search(state, query) do
    Enum.filter(state, fn item ->
      String.contains?(String.downcase(item["title"]), String.downcase(query))
    end)
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
