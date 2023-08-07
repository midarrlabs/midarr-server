defmodule MediaServerWeb.MoviesControllerTest do
  use MediaServerWeb.ConnCase

  use Plug.Test

  setup do
    %{user: MediaServer.AccountsFixtures.user_fixture()}
  end

  test "it should have all", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/movies?token=#{user.api_token.token}")

    assert conn.status === 200

    assert conn.resp_body ===
             "{\"items\":[{\"id\":3,\"poster\":\"https://image.tmdb.org/t/p/original/753kJbZ5iS7DUomTKX9qF5Cs5NY.jpg\",\"title\":\"Caminandes:  Llamigos\"},{\"id\":2,\"poster\":\"https://image.tmdb.org/t/p/original/7YtEiEzRBVCr8Sbgo1kVsr3OCMk.jpg\",\"title\":\"Caminandes: Gran Dillama\"},{\"id\":1,\"poster\":\"https://image.tmdb.org/t/p/original/66VPke0YSiyfe97aobbcZ55ts56.jpg\",\"title\":\"Caminandes: Llama Drama\"}],\"next_page\":\"/api/movies?page=2\",\"prev_page\":\"/api/movies?page=0\",\"total\":3}"  end

  test "it should have all paged", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/movies?page=1&token=#{user.api_token.token}")

    assert conn.status === 200

    assert conn.resp_body ===
             "{\"items\":[{\"id\":3,\"poster\":\"https://image.tmdb.org/t/p/original/753kJbZ5iS7DUomTKX9qF5Cs5NY.jpg\",\"title\":\"Caminandes:  Llamigos\"},{\"id\":2,\"poster\":\"https://image.tmdb.org/t/p/original/7YtEiEzRBVCr8Sbgo1kVsr3OCMk.jpg\",\"title\":\"Caminandes: Gran Dillama\"},{\"id\":1,\"poster\":\"https://image.tmdb.org/t/p/original/66VPke0YSiyfe97aobbcZ55ts56.jpg\",\"title\":\"Caminandes: Llama Drama\"}],\"next_page\":\"/api/movies?page=2\",\"prev_page\":\"/api/movies?page=0\",\"total\":3}"  end

  test "it should NOT have all paged", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/movies?page=2&token=#{user.api_token.token}")

    assert conn.status === 200

    assert conn.resp_body ===
             "{\"items\":[],\"next_page\":\"/api/movies?page=3\",\"prev_page\":\"/api/movies?page=1\",\"total\":3}"
  end

  test "it should have genre", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/movies?genre=animation&token=#{user.api_token.token}")

    assert conn.status === 200

    assert conn.resp_body ===
             "{\"items\":[{\"id\":3,\"poster\":\"https://image.tmdb.org/t/p/original/753kJbZ5iS7DUomTKX9qF5Cs5NY.jpg\",\"title\":\"Caminandes:  Llamigos\"},{\"id\":2,\"poster\":\"https://image.tmdb.org/t/p/original/7YtEiEzRBVCr8Sbgo1kVsr3OCMk.jpg\",\"title\":\"Caminandes: Gran Dillama\"},{\"id\":1,\"poster\":\"https://image.tmdb.org/t/p/original/66VPke0YSiyfe97aobbcZ55ts56.jpg\",\"title\":\"Caminandes: Llama Drama\"}],\"next_page\":\"/api/movies?page=2\",\"prev_page\":\"/api/movies?page=0\",\"total\":3}"  end

  test "it should NOT have genre", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/movies?genre=history&token=#{user.api_token.token}")

    assert conn.status === 200

    assert conn.resp_body ===
             "{\"items\":[],\"next_page\":\"/api/movies?page=2\",\"prev_page\":\"/api/movies?page=0\",\"total\":0}"
  end

  test "it should have genre paged", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/movies?genre=animation&page=1&token=#{user.api_token.token}")

    assert conn.status === 200

    assert conn.resp_body ===
             "{\"items\":[{\"id\":3,\"poster\":\"https://image.tmdb.org/t/p/original/753kJbZ5iS7DUomTKX9qF5Cs5NY.jpg\",\"title\":\"Caminandes:  Llamigos\"},{\"id\":2,\"poster\":\"https://image.tmdb.org/t/p/original/7YtEiEzRBVCr8Sbgo1kVsr3OCMk.jpg\",\"title\":\"Caminandes: Gran Dillama\"},{\"id\":1,\"poster\":\"https://image.tmdb.org/t/p/original/66VPke0YSiyfe97aobbcZ55ts56.jpg\",\"title\":\"Caminandes: Llama Drama\"}],\"next_page\":\"/api/movies?page=2\",\"prev_page\":\"/api/movies?page=0\",\"total\":3}"  end

  test "it should NOT have genre paged", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/movies?genre=history&page=1&token=#{user.api_token.token}")

    assert conn.status === 200

    assert conn.resp_body ===
             "{\"items\":[],\"next_page\":\"/api/movies?page=2\",\"prev_page\":\"/api/movies?page=0\",\"total\":0}"
  end

  test "it should sort by latest", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/movies?sort_by=latest&token=#{user.api_token.token}")

    assert conn.status === 200

    assert conn.resp_body ===
             "{\"items\":[{\"id\":3,\"poster\":\"https://image.tmdb.org/t/p/original/753kJbZ5iS7DUomTKX9qF5Cs5NY.jpg\",\"title\":\"Caminandes:  Llamigos\"},{\"id\":2,\"poster\":\"https://image.tmdb.org/t/p/original/7YtEiEzRBVCr8Sbgo1kVsr3OCMk.jpg\",\"title\":\"Caminandes: Gran Dillama\"},{\"id\":1,\"poster\":\"https://image.tmdb.org/t/p/original/66VPke0YSiyfe97aobbcZ55ts56.jpg\",\"title\":\"Caminandes: Llama Drama\"}],\"next_page\":\"/api/movies?page=2\",\"prev_page\":\"/api/movies?page=0\",\"total\":3}"  end

  test "it should sort by latest paged", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/movies?sort_by=latest&page=1&token=#{user.api_token.token}")

    assert conn.status === 200

    assert conn.resp_body ===
             "{\"items\":[{\"id\":3,\"poster\":\"https://image.tmdb.org/t/p/original/753kJbZ5iS7DUomTKX9qF5Cs5NY.jpg\",\"title\":\"Caminandes:  Llamigos\"},{\"id\":2,\"poster\":\"https://image.tmdb.org/t/p/original/7YtEiEzRBVCr8Sbgo1kVsr3OCMk.jpg\",\"title\":\"Caminandes: Gran Dillama\"},{\"id\":1,\"poster\":\"https://image.tmdb.org/t/p/original/66VPke0YSiyfe97aobbcZ55ts56.jpg\",\"title\":\"Caminandes: Llama Drama\"}],\"next_page\":\"/api/movies?page=2\",\"prev_page\":\"/api/movies?page=0\",\"total\":3}"  end
end
