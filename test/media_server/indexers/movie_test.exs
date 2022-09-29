defmodule MediaServer.Indexers.MovieTest do
  use ExUnit.Case, async: true

  alias MediaServer.Indexers.Movie, as: Indexer
  alias MediaServerWeb.Repositories.Movies

  setup do
    {:ok, bucket} = Indexer.start_link()
    %{bucket: bucket}
  end

  test "it should get all", %{bucket: bucket} do
    assert Indexer.get_all(bucket) == Movies.get_all()
  end
end