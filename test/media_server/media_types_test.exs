defmodule MediaServer.MediaTypesTest do
  use MediaServer.DataCase

  test "create/1 with valid data creates" do
    assert {:ok, %MediaServer.MediaTypes{} = media} = MediaServer.MediaTypes.create(%{type: "some type"})
    assert media.type == "some type"
  end

  test "create/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = MediaServer.MediaTypes.create(%{type: nil})
  end
  
  test "it should get id" do
    assert {:ok, %MediaServer.MediaTypes{} = media} = MediaServer.MediaTypes.create(%{type: "some type"})

    assert MediaServer.MediaTypes.get_id("some type") === media.id
  end
end
