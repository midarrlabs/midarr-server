defmodule MediaServer.UserContinuesTest do
  use MediaServer.DataCase

  test "it should create" do
    user = MediaServer.AccountsFixtures.user_fixture()

    assert {:ok, %MediaServer.Accounts.UserContinues{} = continue} = MediaServer.Accounts.UserContinues.create(%{
             media_id: 1,
             current_time: 2,
             duration: 3,
             user_id: user.id,
             media_type_id: MediaServer.MediaTypes.get_id("movie")
           })
    assert continue.media_id == 1
    assert continue.current_time == 2
    assert continue.duration == 3
    assert continue.user_id == user.id
    assert continue.media_type_id == MediaServer.MediaTypes.get_id("movie")
  end

  test "it should error" do
    assert {:error, %Ecto.Changeset{}} = MediaServer.Accounts.UserContinues.create(%{type: nil})
  end
end
