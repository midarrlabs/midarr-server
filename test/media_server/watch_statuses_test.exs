defmodule MediaServer.WatchStatusesTest do
  use MediaServer.DataCase

  alias MediaServer.WatchStatuses

  describe "movie_watch_statuses" do
    alias MediaServer.WatchStatuses.Movie

    import MediaServer.WatchStatusesFixtures

    @invalid_attrs %{movie_id: nil, timestamp: nil}

    test "list_movie_watch_statuses/0 returns all movie_watch_statuses" do
      movie = movie_fixture()
      assert WatchStatuses.list_movie_watch_statuses() == [movie]
    end

    test "get_movie!/1 returns the movie with given id" do
      movie = movie_fixture()
      assert WatchStatuses.get_movie!(movie.id) == movie
    end

    test "create_movie/1 with valid data creates a movie" do
      valid_attrs = %{movie_id: 42, timestamp: 42}

      assert {:ok, %Movie{} = movie} = WatchStatuses.create_movie(valid_attrs)
      assert movie.movie_id == 42
      assert movie.timestamp == 42
    end

    test "create_movie/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WatchStatuses.create_movie(@invalid_attrs)
    end

    test "update_movie/2 with valid data updates the movie" do
      movie = movie_fixture()
      update_attrs = %{movie_id: 43, timestamp: 43}

      assert {:ok, %Movie{} = movie} = WatchStatuses.update_movie(movie, update_attrs)
      assert movie.movie_id == 43
      assert movie.timestamp == 43
    end

    test "update_movie/2 with invalid data returns error changeset" do
      movie = movie_fixture()
      assert {:error, %Ecto.Changeset{}} = WatchStatuses.update_movie(movie, @invalid_attrs)
      assert movie == WatchStatuses.get_movie!(movie.id)
    end

    test "update_or_create_movie/2 updates movie" do
      movie = movie_fixture()
      update_attrs = %{movie_id: 42, timestamp: 43}

      assert {:ok, %Movie{} = movie} = WatchStatuses.update_or_create_movie(movie.movie_id, update_attrs)
      assert movie.movie_id == 42
      assert movie.timestamp == 43
    end

    test "update_or_create_movie/2 creates movie" do
      movie = movie_fixture()
      update_attrs = %{movie_id: 43, timestamp: 43}

      assert {:ok, %Movie{} = movie} = WatchStatuses.update_or_create_movie(movie.movie_id, update_attrs)
      assert movie.movie_id == 43
      assert movie.timestamp == 43
    end

    test "delete_movie/1 deletes the movie" do
      movie = movie_fixture()
      assert {:ok, %Movie{}} = WatchStatuses.delete_movie(movie)
      assert_raise Ecto.NoResultsError, fn -> WatchStatuses.get_movie!(movie.id) end
    end

    test "change_movie/1 returns a movie changeset" do
      movie = movie_fixture()
      assert %Ecto.Changeset{} = WatchStatuses.change_movie(movie)
    end
  end
end
