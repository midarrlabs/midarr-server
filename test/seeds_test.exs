defmodule MediaServerWeb.SeedsTest do
  use MediaServer.DataCase

  test "it has genres" do
    assert Enum.count(MediaServer.Repo.all(MediaServer.Genres)) == 27
  end
end
