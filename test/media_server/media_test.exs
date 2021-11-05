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
    alias MediaServer.Media.Util

    import MediaServer.MediaFixtures

    @invalid_attrs %{name: "", path: ""}

    test "list_files/0 returns all files" do
      file = file_fixture()
      assert Media.list_files() == [file]
    end

    test "get_file!/1 returns the file with given id" do
      file = file_fixture()
      assert Media.get_file!(file.id) == file
    end

    test "create_file/1 with valid data creates a file" do
      library = library_fixture()
      valid_attrs = %{name: "some name", path: "some path", library_id: library.id}

      assert {:ok, %MediaServer.Media.File{} = _file} = Media.create_file(valid_attrs)
    end

    test "create_file/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Media.create_file(@invalid_attrs)
    end

    test "update_file/2 with valid data updates the file" do
      file = file_fixture()
      update_attrs = %{name: "some update name", path: "some update path"}

      assert {:ok, %MediaServer.Media.File{} = _file} = Media.update_file(file, update_attrs)
    end

    test "update_file/2 with invalid data returns error changeset" do
      file = file_fixture()
      assert {:error, %Ecto.Changeset{}} = Media.update_file(file, @invalid_attrs)
      assert file == Media.get_file!(file.id)
    end

    test "delete_file/1 deletes the file" do
      file = file_fixture()
      assert {:ok, %MediaServer.Media.File{}} = Media.delete_file(file)
      assert_raise Ecto.NoResultsError, fn -> Media.get_file!(file.id) end
    end

    test "change_file/1 returns a file changeset" do
      file = file_fixture()
      assert %Ecto.Changeset{} = Media.change_file(file)
    end

    test "get_file_paths" do

      assert Util.get_file_paths("samples/movies") == [
        "samples/movies/Big Buck Bunny (2008)/Big.Buck.Bunny.2008.720p.BluRay.H264.PROVIDER.mkv",
        "samples/movies/Big Buck Bunny (2008)/Big.Buck.Bunny.2008.720p.BluRay.H264.PROVIDER.mp4"
      ]
    end

    test "persist_file" do

      library = library_fixture()

      MediaServer.Media.Watcher.persist_file("samples/movies/Big Buck Bunny (2008)/Big.Buck.Bunny.2008.720p.BluRay.H264.PROVIDER.mp4")

      assert Repo.exists?(from f in MediaServer.Media.File, where: f.library_id == ^library.id and f.path == "samples/movies/Big Buck Bunny (2008)/Big.Buck.Bunny.2008.720p.BluRay.H264.PROVIDER.mp4")
    end
  end
end
