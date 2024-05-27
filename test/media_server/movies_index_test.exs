defmodule MediaServer.MoviesIndexTest do
  use MediaServer.DataCase

  test "it should have started" do
    {:error, {:already_started, _pid}} = MediaServer.MoviesIndex.start_link([])
  end

  describe "db index" do
    test "inserts new items into the database" do
      items = [
        %{"type_id" => 1, "external_id" => 1234},
        %{"type_id" => 2, "external_id" => 5678}
      ]

      assert :ok = MediaServer.ItemInserter.perform(%Oban.Job{args: %{"items" => items}})

      assert MediaServer.Repo.all(MediaServer.Media) |> length() == 2

      assert MediaServer.Repo.get(MediaServer.Media, 1).type_id == 1
      assert MediaServer.Repo.get(MediaServer.Media, 1).external_id == 1234

      assert MediaServer.Repo.get(MediaServer.Media, 2).type_id == 2
      assert MediaServer.Repo.get(MediaServer.Media, 2).external_id == 5678
    end
  end
end
