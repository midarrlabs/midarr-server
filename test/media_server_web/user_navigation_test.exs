defmodule MediaServerWeb.UserNavigationTest do
  use MediaServerWeb.ConnCase

  import ExUnit.CaptureIO
  import Phoenix.LiveViewTest

  setup %{conn: conn} do
    %{conn: conn |> log_in_user(MediaServer.AccountsFixtures.user_fixture())}
  end

  test "it should log", %{conn: conn} do
    captured = capture_io(fn ->
      live(conn, ~p"/movies")
    end)

    assert String.contains?(captured, "Some Name: http://www.example.com/movies\nSome Name: http://www.example.com/movies\n")
  end
end
