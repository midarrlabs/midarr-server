defmodule MediaServer.ContinuesTest do
  use MediaServer.DataCase

  alias MediaServer.AccountsFixtures

  test "should find" do
    user = AccountsFixtures.user_fixture()
    media = MediaServer.ContinuesFixtures.create(%{user_id: user.id})
    assert MediaServer.Accounts.UserContinues.find(media.id) == media
  end

  test "it should create" do
    user = AccountsFixtures.user_fixture()

    assert {:ok, %MediaServer.Accounts.UserContinues{} = continue} = MediaServer.Accounts.UserContinues.create(%{
             media_id: 42,
             current_time: 42,
             duration: 84,
             user_id: user.id,
             media_type_id: MediaServer.MediaTypes.get_id("movie")
           })

    assert continue.media_id == 42
    assert continue.current_time == 42
    assert continue.duration == 84
    assert continue.user_id == user.id
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

    assert {:ok, %MediaServer.Accounts.UserContinues{} = continue} = MediaServer.Accounts.UserContinues.update(continue.id, %{
             media_id: 42,
             current_time: 62,
             duration: 86,
             user_id: user.id
           })

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

    {:ok, %MediaServer.Accounts.UserContinues{} = continue} = MediaServer.Accounts.UserContinues.update_or_create(%{
      media_id: 42,
      current_time: 89,
      duration: 100,
      user_id: user.id
    })

    assert continue.media_id == 42
    assert continue.current_time == 89
    assert continue.duration == 100
    assert continue.user_id == user.id
  end

  test "it should delete on update or create" do
    user = AccountsFixtures.user_fixture()
    MediaServer.ContinuesFixtures.create(%{user_id: user.id})

    refute MediaServer.Accounts.UserContinues.update_or_create(%{
      media_id: 42,
      current_time: 90,
      duration: 100,
      user_id: user.id
    })
  end

  test "it should create on update or create" do
    user = AccountsFixtures.user_fixture()
    MediaServer.ContinuesFixtures.create(%{user_id: user.id})

    assert {:ok, %MediaServer.Accounts.UserContinues{} = continue} = MediaServer.Accounts.UserContinues.update_or_create(%{
             media_id: 42,
             current_time: 62,
             duration: 86,
             user_id: user.id
           })

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
end
