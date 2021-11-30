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
        name: "Movies",
        path: "/movies"
      })
      |> MediaServer.Media.create_library()

    library
  end

  @doc """
  Generate a file.
  """
  def file_fixture(attrs \\ %{}) do
    
    library = library_fixture()

    {:ok, file} =
      attrs
      |> Enum.into(%{
        path: "samples/movies/Elephant Dreams (2008)/Elephant.Dreams.2008.mkv",
        library_id: library.id
      })
      |> MediaServer.Media.create_file()

    file
  end
end
