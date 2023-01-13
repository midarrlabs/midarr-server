defmodule MediaServer.SeriesWebhook do
  use Agent

  alias MediaServerWeb.Repositories.Series

  def start_link(_opts) do
    Agent.start_link(fn -> Series.set_notification() end, name: __MODULE__)
  end
end
