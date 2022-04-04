defmodule MediaServerWeb.FavouritesLiveTest do
  use MediaServerWeb.ConnCase

  alias MediaServer.AccountsFixtures

  defp create_fixtures(_) do
    %{user: AccountsFixtures.user_fixture()}
  end

  describe "Index" do
    setup [:create_fixtures]

    test "page", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      conn = get(conn, Routes.favourites_index_path(conn, :index))
      assert html_response(conn, 200)
    end
  end
end
