defmodule MediaServer.Indexers.MovieTest do
  use ExUnit.Case, async: true

  alias MediaServer.Indexers.Movie

  setup do
    {:ok, bucket} = Movie.start_link([])
    %{bucket: bucket}
  end

  test "stores values by key", %{bucket: bucket} do
    assert Movie.get(bucket, "milk") == nil

    Movie.put(bucket, "milk", 3)
    assert Movie.get(bucket, "milk") == 3
  end
end