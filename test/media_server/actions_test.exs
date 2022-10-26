defmodule MediaServer.ActionsTest do
  use MediaServer.DataCase

  test "list_movie_actions/0 returns all movie_actions" do
    movie = MediaServer.ActionsFixtures.create()
    assert MediaServer.Accounts.UserMedia.all() == [movie]
  end

  test "get_movie!/1 returns the movie with given id" do
    movie = MediaServer.ActionsFixtures.create()
    assert MediaServer.Accounts.UserMedia.get(movie.id) == movie
  end
end
