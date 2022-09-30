defmodule MediaServer.Indexers.MovieTest do
  use ExUnit.Case

  alias MediaServer.Indexers.Movie, as: Indexer
  alias MediaServerWeb.Repositories.Movies

  test "it should get all" do
    assert Indexer.get_all() == Movies.get_all()
  end
end
