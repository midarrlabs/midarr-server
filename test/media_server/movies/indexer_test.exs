defmodule MediaServer.Movies.IndexerTest do
  use ExUnit.Case

  alias MediaServer.Movies.Indexer
  alias MediaServerWeb.Repositories.Movies

  test "it should get all" do
    assert Indexer.get_all() == Movies.get_all()
  end
end
