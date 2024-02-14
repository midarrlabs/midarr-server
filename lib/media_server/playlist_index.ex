defmodule MediaServer.PlaylistIndex do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(init_arg) do
    :ets.new(:playlists_table, [:public, :named_table])

    {:ok, init_arg}
  end
end
