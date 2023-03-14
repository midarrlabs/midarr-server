defmodule MediaServerWeb.ImagesControllerTest do
  use MediaServerWeb.ConnCase

  test "it should get movie poster", %{conn: conn} do
    token = Phoenix.Token.sign(MediaServerWeb.Endpoint, "user auth", "id")

    conn = get(conn, Routes.images_path(conn, :index), movie: "1", type: "poster")

    assert conn.status === 200
    assert conn.state === :sent

    assert is_binary(conn.resp_body)
  end
end
