defmodule MediaServer.ItemInserter do
  use Oban.Worker, queue: :default, max_attempts: 3

  @impl true
  def perform(%Oban.Job{args: %{"items" => items}}) do
    items
    |> Enum.each(fn item ->
      MediaServer.Media.insert_record(%{
        type_id: item["type_id"],
        external_id: item["external_id"]
      })
    end)

    :ok
  end
end
