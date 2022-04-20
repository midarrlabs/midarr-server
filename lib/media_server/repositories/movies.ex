defmodule MediaServer.Repositories.Movies do
  use Agent

  alias MediaServerWeb.Repositories.Movies

  def start_link(_opts) do
    Agent.start_link(fn -> Movies.get_all() end)
  end

  def get_all(pid) do
    Agent.get(pid, fn state -> state end)
  end
end
