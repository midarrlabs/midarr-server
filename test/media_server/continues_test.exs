defmodule MediaServer.ContinuesTest do
  use MediaServer.DataCase

  alias MediaServer.AccountsFixtures
  alias MediaServer.Continues

  test "should find" do
    user = AccountsFixtures.user_fixture()
    movie = MediaServer.ContinuesFixtures.create(%{user_id: user.id})
    assert MediaServer.Accounts.UserContinues.find(movie.id) == movie
  end

  test "it should create" do
    user = AccountsFixtures.user_fixture()

    valid_attrs = %{
      media_id: 42,
      current_time: 42,
      duration: 84,
      user_id: user.id,
      media_type_id: MediaServer.MediaTypes.get_id("movie")
    }

    assert {:ok, %MediaServer.Accounts.UserContinues{} = continue} = MediaServer.Accounts.UserContinues.create(valid_attrs)
    assert continue.media_id == 42
    assert continue.current_time == 42
    assert continue.duration == 84
    assert continue.user_id == user.id
    assert continue.media_type_id == MediaServer.MediaTypes.get_id("movie")
  end

  test "it should error on create" do
    assert {:error, %Ecto.Changeset{}} = MediaServer.Accounts.UserContinues.create(%{
             media_id: nil,
             current_time: nil,
             duration: nil,
             user_id: nil
           })
  end

  test "it should update" do
    user = AccountsFixtures.user_fixture()
    continue = MediaServer.ContinuesFixtures.create(%{user_id: user.id})

    update_attrs = %{
      media_id: 42,
      current_time: 62,
      duration: 86,
      user_id: user.id
    }

    assert {:ok, %MediaServer.Accounts.UserContinues{} = continue} = MediaServer.Accounts.UserContinues.update(continue.id, update_attrs)
    assert continue.media_id == 42
    assert continue.current_time == 62
    assert continue.duration == 86
  end

  test "it should error on update" do
    user = AccountsFixtures.user_fixture()
    continue = MediaServer.ContinuesFixtures.create(%{user_id: user.id})
    assert {:error, %Ecto.Changeset{}} = MediaServer.Accounts.UserContinues.update(continue.id, %{
             media_id: nil,
             current_time: nil,
             duration: nil,
             user_id: nil
           })
    assert continue == MediaServer.Accounts.UserContinues.find(continue.id)
  end

  test "it should update on update or create" do
    user = AccountsFixtures.user_fixture()
    MediaServer.ContinuesFixtures.create(%{user_id: user.id})

    update_attrs = %{
      media_id: 42,
      current_time: 89,
      duration: 100,
      user_id: user.id
    }

    {:ok, %MediaServer.Accounts.UserContinues{} = continue} = MediaServer.Accounts.UserContinues.update_or_create(update_attrs)
    assert continue.media_id == 42
    assert continue.current_time == 89
    assert continue.duration == 100
    assert continue.user_id == user.id
  end

  test "it should delete on update or create" do
    user = AccountsFixtures.user_fixture()
    MediaServer.ContinuesFixtures.create(%{user_id: user.id})

    update_attrs = %{
      media_id: 42,
      current_time: 90,
      duration: 100,
      user_id: user.id
    }

    refute MediaServer.Accounts.UserContinues.update_or_create(update_attrs)
  end

  test "it should create on update or create" do
    user = AccountsFixtures.user_fixture()
    MediaServer.ContinuesFixtures.create(%{user_id: user.id})

    update_attrs = %{
      media_id: 42,
      current_time: 62,
      duration: 86,
      user_id: user.id
    }

    assert {:ok, %MediaServer.Accounts.UserContinues{} = continue} = MediaServer.Accounts.UserContinues.update_or_create(update_attrs)
    assert continue.media_id == 42
    assert continue.current_time == 62
    assert continue.duration == 86
    assert continue.user_id == user.id
  end

  test "it should delete" do
    user = AccountsFixtures.user_fixture()
    continue = MediaServer.ContinuesFixtures.create(%{user_id: user.id})
    assert {:ok, %MediaServer.Accounts.UserContinues{}} = MediaServer.Accounts.UserContinues.delete(continue.id)
    assert_raise Ecto.NoResultsError, fn -> MediaServer.Accounts.UserContinues.find(continue.id) end
  end

  describe "episode_continues" do
    alias MediaServer.Episodes.Continue, as: Episode

    import MediaServer.ContinuesFixtures

    @invalid_attrs %{
      current_time: nil,
      duration: nil,
      episode_id: nil,
      image_url: nil,
      serie_id: nil,
      title: nil,
      user_id: nil
    }

    test "list_episode_continues/0 returns all episode_continues" do
      user = AccountsFixtures.user_fixture()
      episode = episode_fixture(%{user_id: user.id})
      assert Continues.list_episode_continues() == [episode]
    end

    test "get_episode!/1 returns the episode with given id" do
      user = AccountsFixtures.user_fixture()
      episode = episode_fixture(%{user_id: user.id})
      assert Continues.get_episode!(episode.id) == episode
    end

    test "create_episode/1 with valid data creates a episode" do
      user = AccountsFixtures.user_fixture()

      valid_attrs = %{
        current_time: 42,
        duration: 42,
        episode_id: 42,
        image_url: "some image_url",
        serie_id: 42,
        title: "some title",
        user_id: user.id
      }

      assert {:ok, %Episode{} = episode} = Continues.create_episode(valid_attrs)
      assert episode.current_time == 42
      assert episode.duration == 42
      assert episode.episode_id == 42
      assert episode.image_url == "some image_url"
      assert episode.serie_id == 42
      assert episode.title == "some title"
      assert episode.user_id == user.id
    end

    test "create_episode/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Continues.create_episode(@invalid_attrs)
    end

    test "update_episode/2 with valid data updates the episode" do
      user = AccountsFixtures.user_fixture()
      episode = episode_fixture(%{user_id: user.id})

      update_attrs = %{
        current_time: 43,
        duration: 43,
        episode_id: 43,
        image_url: "some updated image_url",
        serie_id: 43,
        title: "some updated title",
        user_id: user.id
      }

      assert {:ok, %Episode{} = episode} = Continues.update_episode(episode, update_attrs)
      assert episode.current_time == 43
      assert episode.duration == 43
      assert episode.episode_id == 43
      assert episode.image_url == "some updated image_url"
      assert episode.serie_id == 43
      assert episode.title == "some updated title"
      assert episode.user_id == user.id
    end

    test "update_episode/2 with invalid data returns error changeset" do
      user = AccountsFixtures.user_fixture()
      episode = episode_fixture(%{user_id: user.id})
      assert {:error, %Ecto.Changeset{}} = Continues.update_episode(episode, @invalid_attrs)
      assert episode == Continues.get_episode!(episode.id)
    end

    test "update_or_create_episode/2 updates episode" do
      user = AccountsFixtures.user_fixture()
      episode_fixture(%{user_id: user.id})

      update_attrs = %{
        episode_id: 42,
        serie_id: 42,
        current_time: 89,
        duration: 100,
        user_id: user.id
      }

      {:ok, %Episode{} = episode} = Continues.update_or_create_episode(update_attrs)
      assert episode.duration == 100
      assert episode.current_time == 89
      assert episode.episode_id == 42
      assert episode.serie_id == 42
      assert episode.user_id == user.id
    end

    test "update_or_create_movie/2 deletes movie" do
      user = AccountsFixtures.user_fixture()
      episode_fixture(%{user_id: user.id})

      update_attrs = %{
        episode_id: 42,
        serie_id: 42,
        current_time: 90,
        duration: 100,
        user_id: user.id
      }

      refute Continues.update_or_create_episode(update_attrs)
    end

    test "update_or_create_episode/2 creates episode" do
      user = AccountsFixtures.user_fixture()
      episode_fixture(%{user_id: user.id})

      update_attrs = %{
        episode_id: 43,
        serie_id: 43,
        title: "update title",
        image_url: "update image url",
        current_time: 62,
        duration: 86,
        user_id: user.id
      }

      assert {:ok, %Episode{} = episode} = Continues.update_or_create_episode(update_attrs)
      assert episode.episode_id == 43
      assert episode.title == "update title"
      assert episode.image_url == "update image url"
      assert episode.current_time == 62
      assert episode.duration == 86
      assert episode.user_id == user.id
    end

    test "delete_episode/1 deletes the episode" do
      user = AccountsFixtures.user_fixture()
      episode = episode_fixture(%{user_id: user.id})
      assert {:ok, %Episode{}} = Continues.delete_episode(episode)
      assert_raise Ecto.NoResultsError, fn -> Continues.get_episode!(episode.id) end
    end

    test "change_episode/1 returns a episode changeset" do
      user = AccountsFixtures.user_fixture()
      episode = episode_fixture(%{user_id: user.id})
      assert %Ecto.Changeset{} = Continues.change_episode(episode)
    end
  end
end
