defmodule MediaServer.WatchStatusesTest do
  use MediaServer.DataCase

  alias MediaServer.AccountsFixtures
  alias MediaServer.WatchStatuses

  describe "movie_watch_statuses" do
    alias MediaServer.WatchStatuses.Movie

    import MediaServer.WatchStatusesFixtures

    @invalid_attrs %{
      movie_id: nil,
      title: nil,
      image_url: nil,
      current_time: nil,
      duration: nil,
      user_id: nil
    }

    test "list_movie_watch_statuses/0 returns all movie_watch_statuses" do
      user = AccountsFixtures.user_fixture()
      movie = movie_fixture(%{user_id: user.id})
      assert WatchStatuses.list_movie_watch_statuses() == [movie]
    end

    test "get_movie!/1 returns the movie with given id" do
      user = AccountsFixtures.user_fixture()
      movie = movie_fixture(%{user_id: user.id})
      assert WatchStatuses.get_movie!(movie.id) == movie
    end

    test "create_movie/1 with valid data creates a movie" do
      valid_attrs = %{
        movie_id: 42,
        title: "some title",
        image_url: "some image url",
        current_time: 42,
        duration: 84,
        user_id: AccountsFixtures.user_fixture().id
      }

      assert {:ok, %Movie{} = movie} = WatchStatuses.create_movie(valid_attrs)
      assert movie.movie_id == 42
      assert movie.title == "some title"
      assert movie.image_url == "some image url"
      assert movie.current_time == 42
      assert movie.duration == 84
    end

    test "create_movie/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WatchStatuses.create_movie(@invalid_attrs)
    end

    test "update_movie/2 with valid data updates the movie" do
      user = AccountsFixtures.user_fixture()
      movie = movie_fixture(%{user_id: user.id})
      update_attrs = %{
        movie_id: 43,
        title: "update title",
        image_url: "update image url",
        current_time: 62,
        duration: 86,
        user_id: user.id
      }

      assert {:ok, %Movie{} = movie} = WatchStatuses.update_movie(movie, update_attrs)
      assert movie.movie_id == 43
      assert movie.title == "update title"
      assert movie.image_url == "update image url"
      assert movie.current_time == 62
      assert movie.duration == 86
    end

    test "update_movie/2 with invalid data returns error changeset" do
      user = AccountsFixtures.user_fixture()
      movie = movie_fixture(%{user_id: user.id})
      assert {:error, %Ecto.Changeset{}} = WatchStatuses.update_movie(movie, @invalid_attrs)
      assert movie == WatchStatuses.get_movie!(movie.id)
    end

    test "update_or_create_movie/2 updates movie" do
      user = AccountsFixtures.user_fixture()
      movie_fixture(%{user_id: user.id})
      update_attrs = %{
        movie_id: 42,
        current_time: 62,
        user_id: user.id
      }

      {:ok, %Movie{} = movie} = WatchStatuses.update_or_create_movie(update_attrs)
      assert movie.current_time == 62
    end

    test "update_or_create_movie/2 creates movie" do
      user = AccountsFixtures.user_fixture()
      movie_fixture(%{user_id: user.id})
      update_attrs = %{
        movie_id: 43,
        title: "update title",
        image_url: "update image url",
        current_time: 62,
        duration: 86,
        user_id: user.id
      }
      assert {:ok, %Movie{} = movie} = WatchStatuses.update_or_create_movie(update_attrs)
      assert movie.movie_id == 43
      assert movie.title == "update title"
      assert movie.image_url == "update image url"
      assert movie.current_time == 62
      assert movie.duration == 86
      assert movie.user_id == user.id
    end

    test "delete_movie/1 deletes the movie" do
      user = AccountsFixtures.user_fixture()
      movie = movie_fixture(%{user_id: user.id})
      assert {:ok, %Movie{}} = WatchStatuses.delete_movie(movie)
      assert_raise Ecto.NoResultsError, fn -> WatchStatuses.get_movie!(movie.id) end
    end

    test "change_movie/1 returns a movie changeset" do
      user = AccountsFixtures.user_fixture()
      movie = movie_fixture(%{user_id: user.id})
      assert %Ecto.Changeset{} = WatchStatuses.change_movie(movie)
    end
  end
end
