defmodule MediaServer.MediaFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MediaServer.Media` context.
  """

  @doc """
  Generate a library.
  """
  def library_fixture(attrs \\ %{}) do
    {:ok, library} =
      attrs
      |> Enum.into(%{
        name: "some name",
        path: "some path"
      })
      |> MediaServer.Media.create_library()

    library
  end
end
