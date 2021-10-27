defmodule MediaServer.MediaTest do
  use MediaServer.DataCase

  alias MediaServer.Media

  describe "libraries" do
    alias MediaServer.Media.Library

    import MediaServer.MediaFixtures

    @invalid_attrs %{name: "", path: ""}

    test "list_libraries/0 returns all libraries" do
      library = library_fixture()
      assert Media.list_libraries() == [library]
    end

    test "get_library!/1 returns the library with given id" do
      library = library_fixture()
      assert Media.get_library!(library.id) == library
    end

    test "create_library/1 with valid data creates a library" do
      valid_attrs = %{name: "some name", path: "some path"}

      assert {:ok, %Library{} = _library} = Media.create_library(valid_attrs)
    end

    test "create_library/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Media.create_library(@invalid_attrs)
    end

    test "update_library/2 with valid data updates the library" do
      library = library_fixture()
      update_attrs = %{name: "some update name", path: "some update path"}

      assert {:ok, %Library{} = _library} = Media.update_library(library, update_attrs)
    end

    test "update_library/2 with invalid data returns error changeset" do
      library = library_fixture()
      assert {:error, %Ecto.Changeset{}} = Media.update_library(library, @invalid_attrs)
      assert library == Media.get_library!(library.id)
    end

    test "delete_library/1 deletes the library" do
      library = library_fixture()
      assert {:ok, %Library{}} = Media.delete_library(library)
      assert_raise Ecto.NoResultsError, fn -> Media.get_library!(library.id) end
    end

    test "change_library/1 returns a library changeset" do
      library = library_fixture()
      assert %Ecto.Changeset{} = Media.change_library(library)
    end
  end

  describe "files" do
    alias MediaServer.Media.File

    import MediaServer.MediaFixtures

    @invalid_attrs %{name: ""}

    test "list_files/0 returns all files" do
      file = file_fixture()
      assert Media.list_files() == [file]
    end

    test "get_file!/1 returns the file with given id" do
      file = file_fixture()
      assert Media.get_file!(file.id) == file
    end

    test "create_file/1 with valid data creates a file" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %File{} = _file} = Media.create_file(valid_attrs)
    end

    test "create_file/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Media.create_file(@invalid_attrs)
    end

    test "update_file/2 with valid data updates the file" do
      file = file_fixture()
      update_attrs = %{name: "some update name"}

      assert {:ok, %File{} = _file} = Media.update_file(file, update_attrs)
    end

    test "update_file/2 with invalid data returns error changeset" do
      file = file_fixture()
      assert {:error, %Ecto.Changeset{}} = Media.update_file(file, @invalid_attrs)
      assert file == Media.get_file!(file.id)
    end

    test "delete_file/1 deletes the file" do
      file = file_fixture()
      assert {:ok, %File{}} = Media.delete_file(file)
      assert_raise Ecto.NoResultsError, fn -> Media.get_file!(file.id) end
    end

    test "change_file/1 returns a file changeset" do
      file = file_fixture()
      assert %Ecto.Changeset{} = Media.change_file(file)
    end
  end
end
