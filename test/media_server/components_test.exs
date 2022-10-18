defmodule MediaServer.ComponentsTest do
  use MediaServer.DataCase

  alias MediaServer.Components

  describe "actions" do
    alias MediaServer.Action

    import MediaServer.ComponentsFixtures

    @invalid_attrs %{name: nil}

    test "list_actions/0 returns all actions" do
      assert Enum.count(Components.list_actions()) === 1
    end

    test "get_action!/1 returns the action with given id" do
      action = action_fixture()
      assert Components.get_action!(action.id) == action
    end

    test "create_action/1 with valid data creates a action" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Action{} = action} = Components.create_action(valid_attrs)
      assert action.name == "some name"
    end

    test "create_action/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Components.create_action(@invalid_attrs)
    end

    test "update_action/2 with valid data updates the action" do
      action = action_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Action{} = action} = Components.update_action(action, update_attrs)
      assert action.name == "some updated name"
    end

    test "update_action/2 with invalid data returns error changeset" do
      action = action_fixture()
      assert {:error, %Ecto.Changeset{}} = Components.update_action(action, @invalid_attrs)
      assert action == Components.get_action!(action.id)
    end

    test "delete_action/1 deletes the action" do
      action = action_fixture()
      assert {:ok, %Action{}} = Components.delete_action(action)
      assert_raise Ecto.NoResultsError, fn -> Components.get_action!(action.id) end
    end

    test "change_action/1 returns a action changeset" do
      action = action_fixture()
      assert %Ecto.Changeset{} = Components.change_action(action)
    end
  end
end
