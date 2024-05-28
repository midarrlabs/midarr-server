defmodule MediaServer.MediaTest do
  use MediaServer.DataCase

  test "inserts new items into the database" do
    items = [
      %{"type_id" => 1, "external_id" => 1234},
      %{"type_id" => 2, "external_id" => 5678}
    ]

    assert :ok = MediaServer.ItemInserter.perform(%Oban.Job{args: %{"items" => items}})

    assert MediaServer.Repo.all(MediaServer.Media) |> length() == 5
  end

  test "broadcasts to media on insert" do
    Phoenix.PubSub.subscribe(MediaServer.PubSub, "media")

    {:ok, _record} = MediaServer.Media.insert_record(%{type_id: 1, external_id: 1234})

    assert_receive {:record_inserted, record}
    assert record.external_id == 1234
  end
end
