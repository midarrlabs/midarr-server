defmodule MediaServer.Fixtures.UserActions do

  def action_fixture(attrs \\ %{}) do
    {:ok, action} =
      attrs
      |> Enum.into(%{
        action: "some action"
      })
      |> MediaServer.Actions.create_action()

    action
  end
end
