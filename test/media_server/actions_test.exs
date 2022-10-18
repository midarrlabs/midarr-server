defmodule MediaServer.ActionsTest do
  use MediaServer.DataCase

  alias MediaServer.AccountsFixtures
  alias MediaServer.ComponentsFixtures
  alias MediaServer.Actions

  describe "movie_actions" do
    alias MediaServer.Movies.Action, as: Movie

    import MediaServer.ActionsFixtures

    @invalid_attrs %{
      movie_id: nil,
      title: nil,
      user_id: nil,
      action_id: nil
    }

    test "list_movie_actions/0 returns all movie_actions" do
      movie = movie_fixture()
      assert Actions.list_movie_actions() == [movie]
    end

    test "get_movie!/1 returns the movie with given id" do
      movie = movie_fixture()
      assert Actions.get_movie!(movie.id) == movie
    end

    test "create_movie/1 with valid data creates a movie" do
      action = ComponentsFixtures.action_fixture()
      user = AccountsFixtures.user_fixture()

      valid_attrs = %{
        movie_id: 42,
        title: "some title",
        user_id: user.id,
        action_id: action.id
      }

      assert {:ok, %Movie{} = movie} = Actions.create_movie(valid_attrs)
      assert movie.movie_id == 42
      assert movie.title == "some title"
    end

    test "create_movie/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Actions.create_movie(@invalid_attrs)
    end

    test "update_movie/2 with valid data updates the movie" do
      movie = movie_fixture()
      update_attrs = %{movie_id: 43, title: "some updated title"}

      assert {:ok, %Movie{} = movie} = Actions.update_movie(movie, update_attrs)
      assert movie.movie_id == 43
      assert movie.title == "some updated title"
    end

    test "update_movie/2 with invalid data returns error changeset" do
      movie = movie_fixture()
      assert {:error, %Ecto.Changeset{}} = Actions.update_movie(movie, @invalid_attrs)
      assert movie == Actions.get_movie!(movie.id)
    end

    test "delete_movie/1 deletes the movie" do
      movie = movie_fixture()
      assert {:ok, %Movie{}} = Actions.delete_movie(movie)
      assert_raise Ecto.NoResultsError, fn -> Actions.get_movie!(movie.id) end
    end

    test "change_movie/1 returns a movie changeset" do
      movie = movie_fixture()
      assert %Ecto.Changeset{} = Actions.change_movie(movie)
    end
  end

  describe "episode_actions" do
    alias MediaServer.Episodes.Action, as: Episode

    import MediaServer.ActionsFixtures

    @invalid_attrs %{episode_id: nil, serie_id: nil, title: nil}

    test "list_episode_actions/0 returns all episode_actions" do
      episode = episode_fixture()
      assert Actions.list_episode_actions() == [episode]
    end

    test "get_episode!/1 returns the episode with given id" do
      episode = episode_fixture()
      assert Actions.get_episode!(episode.id) == episode
    end

    test "create_episode/1 with valid data creates a episode" do
      action = ComponentsFixtures.action_fixture()
      user = AccountsFixtures.user_fixture()

      valid_attrs = %{
        episode_id: 42,
        serie_id: 42,
        title: "some title",
        user_id: user.id,
        action_id: action.id
      }

      assert {:ok, %Episode{} = episode} = Actions.create_episode(valid_attrs)
      assert episode.episode_id == 42
      assert episode.serie_id == 42
      assert episode.title == "some title"
    end

    test "create_episode/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Actions.create_episode(@invalid_attrs)
    end

    test "update_episode/2 with valid data updates the episode" do
      episode = episode_fixture()
      update_attrs = %{episode_id: 43, serie_id: 43, title: "some updated title"}

      assert {:ok, %Episode{} = episode} = Actions.update_episode(episode, update_attrs)
      assert episode.episode_id == 43
      assert episode.serie_id == 43
      assert episode.title == "some updated title"
    end

    test "update_episode/2 with invalid data returns error changeset" do
      episode = episode_fixture()
      assert {:error, %Ecto.Changeset{}} = Actions.update_episode(episode, @invalid_attrs)
      assert episode == Actions.get_episode!(episode.id)
    end

    test "delete_episode/1 deletes the episode" do
      episode = episode_fixture()
      assert {:ok, %Episode{}} = Actions.delete_episode(episode)
      assert_raise Ecto.NoResultsError, fn -> Actions.get_episode!(episode.id) end
    end

    test "change_episode/1 returns a episode changeset" do
      episode = episode_fixture()
      assert %Ecto.Changeset{} = Actions.change_episode(episode)
    end
  end
end
