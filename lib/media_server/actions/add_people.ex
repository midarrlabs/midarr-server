defmodule MediaServer.AddPeople do
  use Oban.Worker, queue: :default, max_attempts: 3

  @impl true
  @spec perform(%{:args => map(), optional(any()) => any()}) :: :ok
  def perform(%Oban.Job{args: %{"items" => items}}) do
    items
    |> Enum.each(fn item ->
      MediaServer.People.insert(%{
        external_id: item["external_id"]
      })
    end)

    :ok
  end
end
