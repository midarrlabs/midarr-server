defmodule MediaServerWeb.SeedsTest do
  use MediaServer.DataCase

  test "it has genres" do
    assert Enum.count(MediaServer.Repo.all(MediaServer.Genres)) == 27
  end

  test "it has movies" do
    assert Enum.count(MediaServer.Repo.all(MediaServer.Movies)) == 3
  end

  test "it has movie genres" do
    assert Enum.count(MediaServer.Repo.all(MediaServer.MovieGenres)) == 9
  end

  test "it has people" do
    assert Enum.count(MediaServer.Repo.all(MediaServer.People)) == 0
  end

  test "it has series" do
    assert Enum.count(MediaServer.Repo.all(MediaServer.Series)) == 1
  end

  test "it has episodes" do
    assert Enum.count(MediaServer.Repo.all(MediaServer.Episodes)) == 6
  end
end
