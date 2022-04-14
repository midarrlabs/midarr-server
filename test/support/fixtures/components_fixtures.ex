defmodule MediaServer.ComponentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MediaServer.Components` context.
  """

  @doc """
  Generate a action.
  """
  def action_fixture(attrs \\ %{}) do
    {:ok, action} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> MediaServer.Components.create_action()

    action
  end
end
