defmodule MediaServer.Api.Token do
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> Phoenix.Token.sign(MediaServerWeb.Endpoint, "auth", __MODULE__) end, name: __MODULE__)
  end

  def get_token() do
    Agent.get(__MODULE__, & &1)
  end
end
