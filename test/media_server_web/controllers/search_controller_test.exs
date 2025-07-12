defmodule SearchControllerTest do
  use MediaServerWeb.ConnCase

  setup %{conn: conn} do
    user = MediaServer.AccountsFixtures.user_fixture()
    movie = MediaServer.Repo.get_by(MediaServer.Movies, id: 1)

    %{conn: conn, user: user, movie: movie}
  end

  test "it should have a movie", %{conn: conn, user: user, movie: movie} do
    conn = get(conn, ~p"/api/search?query=#{movie.title}&token=#{user.api_token.token}")

    [first | _] = json_response(conn, 200)["data"]["movies"]

    assert is_binary(first["title"])
  end

  test "it should have a series", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/search?query=pio&token=#{user.api_token.token}")

    [first | _] = json_response(conn, 200)["data"]["series"]

    assert is_binary(first["title"])
  end
end
