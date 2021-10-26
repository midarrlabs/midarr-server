defmodule MediaServer.LibrariesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MediaServer.Libraries` context.
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
      |> MediaServer.Libraries.create_library()

    library
  end
end
