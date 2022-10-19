defmodule MediaServer.UserActionsTest do
  use MediaServer.DataCase

  test "list_actions/0 returns all actions" do
    assert Enum.count(MediaServer.Action.list_actions()) === 1
  end

  test "create_action/1 with valid data creates a action" do
    assert {:ok, %MediaServer.Action{} = action} = MediaServer.Action.create_action(%{action: "some action"})
    assert action.action == "some action"
  end

  test "create_action/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = MediaServer.Action.create_action(%{action: nil})
  end
end
