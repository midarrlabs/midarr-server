defmodule MediaServer.SeriesIndex do
  use Agent

  alias MediaServerWeb.Repositories.Series

  def start_link(_opts) do
    Agent.start_link(fn -> Series.get_all() end, name: __MODULE__)
  end

  def reset() do
    Agent.cast(__MODULE__, fn _state -> Series.get_all() end)
  end

  def get_all() do
    Agent.get(__MODULE__, & &1)
  end

  def get_latest(amount) do
    get_all()
    |> Enum.sort_by(& &1["added"], :desc)
    |> Enum.take(amount)
  end

  def get_serie(id) do
    get_all()
    |> Enum.find(fn item -> item["id"] === String.to_integer(id) end)
  end

  def get_poster(series) do
    (Enum.filter(series["images"], fn item -> item["coverType"] === "poster" end)
     |> Enum.at(0))["remoteUrl"]
  end

  def get_background(series) do
    (Enum.filter(series["images"], fn item -> item["coverType"] === "fanart" end)
     |> Enum.at(0))["remoteUrl"]
  end

  def get_episode_title(id) do
    episode = Agent.get(__MODULE__, & &1)
              |> Enum.find(fn item -> item["id"] === id end)

    episode["title"]
  end
end
