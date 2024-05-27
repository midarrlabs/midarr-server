defmodule MediaServer.ItemInserter do
  use Oban.Worker, queue: :default, max_attempts: 3

  @impl true
  def perform(%Oban.Job{args: %{"items" => items}}) do
    items
    |> Enum.each(&insert_item/1)

    :ok
  end

  defp insert_item(item) do
    MediaServer.Repo.insert!(
      %MediaServer.Media{
        type_id: item["type_id"],
        external_id: item["external_id"]
        },
        on_conflict: :nothing,
        conflict_target: [:type_id, :external_id])
  end
end
