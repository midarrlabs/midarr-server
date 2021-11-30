defmodule MediaServerWeb.LibraryLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest
  import MediaServer.MediaFixtures

  alias MediaServer.Media

  @create_attrs %{name: "some create name", path: "samples"}
  @update_attrs %{name: "some update name", path: "some update path"}
  @invalid_attrs %{name: "", path: ""}

  defp create_library(_) do
    library = library_fixture()
    %{library: library}
  end

  describe "Index" do
    setup [:create_library]

    test "lists all libraries", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.library_index_path(conn, :index))

      assert html =~ "Listing Libraries"
    end

    test "saves new library", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.library_index_path(conn, :index))

      assert index_live |> element("a", "New Library") |> render_click() =~
               "New Library"

      assert_patch(index_live, Routes.library_index_path(conn, :new))

      assert index_live
             |> form("#library-form", library: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#library-form", library: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.library_index_path(conn, :index))

      assert html =~ "Movies"

      {:ok, file} = Enum.fetch(Media.list_files(), 0)

      assert file.title == "Elephant Dreams"
      assert file.year == 2008
    end

    test "updates library in listing", %{conn: conn, library: library} do
      {:ok, index_live, _html} = live(conn, Routes.library_index_path(conn, :index))

      assert index_live |> element("#library-#{library.id} a", "Edit") |> render_click() =~
               "Edit Library"

      assert_patch(index_live, Routes.library_index_path(conn, :edit, library))

      assert index_live
             |> form("#library-form", library: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#library-form", library: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.library_index_path(conn, :index))

      assert html =~ "some update name"
    end

    test "deletes library in listing", %{conn: conn, library: library} do
      {:ok, index_live, _html} = live(conn, Routes.library_index_path(conn, :index))

      assert index_live |> element("#library-#{library.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#library-#{library.id}")
    end
  end

  describe "Show" do
    setup [:create_library]

    test "displays library", %{conn: conn, library: library} do
      {:ok, _show_live, html} = live(conn, Routes.library_show_path(conn, :show, library))

      assert html =~ "Movies"
    end
  end
end
