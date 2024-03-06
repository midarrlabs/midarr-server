defmodule MediaServer.MediaProducer do
  use GenStage

  def start_link(opts) do
    GenStage.start_link(__MODULE__, opts, name: opts.name)
  end

  def init(opts), do: {:producer, opts.state}

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
