defmodule MediaServer.Repositories.Movies do
  use Agent

  alias MediaServerWeb.Repositories.Movies

  def start_link(_opts) do
    Agent.start_link(fn -> Movies.get_all() end)
  end

  def get_all(pid) do
    Agent.get(pid, fn state -> state end)
  end

  def get_movie(pid, id) do
    Agent.get(pid, fn state ->
      Enum.filter(state, fn item -> item["id"] === id end)
      |> List.first()
    end)
  end

  def get_latest(pid, amount) do
    Agent.get(pid, fn state ->
      Enum.filter(state, fn item -> item["hasFile"] end)
      |> Enum.sort_by(& &1["movieFile"]["dateAdded"], :desc)
      |> Enum.take(amount)
    end)
  end

  def get_path(pid, id) do
    movie =
      Agent.get(pid, fn state ->
        Enum.filter(state, fn item -> item["id"] === id end)
        |> List.first()
      end)

    movie["movieFile"]["path"]
  end
end
