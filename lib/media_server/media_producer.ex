defmodule MediaServer.MediaProducer do
  use GenStage

  alias MediaServerWeb.Repositories.Movies

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_opts), do: {:producer, Movies.get_all()}

  def handle_demand(demand, state) do
    {batch, remaining_state} =
      Enum.take(state, demand)
      |> Enum.reduce({[], []}, fn x, {batch, remaining} ->
        {[x | batch], remaining}
      end)

    remaining_state = if length(remaining_state) > 0, do: state, else: remaining_state

    {:noreply, batch, remaining_state}
  end
end
