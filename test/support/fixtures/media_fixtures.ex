defmodule MediaServer.MediaFixtures do

  alias MediaServer.Repo
  alias MediaServer.Media.Type

  @moduledoc """
  This module defines test helpers for creating
  entities via the `MediaServer.Media` context.
  """
  def type_fixture(_attrs \\ %{}) do

    {:ok, type} = Repo.insert(Type.changeset(%Type{}, %{name: "Movie"}))

    type
  end


  @doc """
  Generate a library.
  """
  def library_fixture(attrs \\ %{}) do

    type = type_fixture()

    {:ok, library} =
      attrs
      |> Enum.into(%{
        name: "Movies",
        path: "/movies",
        type_id: type.id
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
