defmodule SearchControllerTest do
  use MediaServerWeb.ConnCase

  use Plug.Test

  setup do
    %{user: MediaServer.AccountsFixtures.user_fixture()}
  end

  test "it should search", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/search?query=Caminandes&token=#{user.api_token.token}")

    assert conn.status === 200

    assert conn.resp_body === "{\"items\":[{\"background\":\"/api/images?movie=3&type=background\",\"overview\":\"In this episode of the Caminandes cartoon series we learn to know our hero Koro even better! It's winter in Patagonia, food is getting scarce. Koro the Llama engages with Oti the pesky penguin in an epic fight over that last tasty berry.  This short animation film was made with Blender and funded by the subscribers of the Blender Cloud platform. Already since 2007, Blender Institute successfully combines film and media production with improving a free and open source 3D creation pipeline.\",\"poster\":\"/api/images?movie=3&type=poster\",\"stream\":\"/api/stream?movie=3\",\"title\":\"Caminandes:  Llamigos\",\"year\":2016},{\"background\":\"/api/images?movie=2&type=background\",\"overview\":\"A young llama named Koro discovers that the grass is always greener on the other side (of the fence).\",\"poster\":\"/api/images?movie=2&type=poster\",\"stream\":\"/api/stream?movie=2\",\"title\":\"Caminandes: Gran Dillama\",\"year\":2013},{\"background\":\"/api/images?movie=1&type=background\",\"overview\":\"Koro wants to get to the other side of the road.\",\"poster\":\"/api/images?movie=1&type=poster\",\"stream\":\"/api/stream?movie=1\",\"title\":\"Caminandes: Llama Drama\",\"year\":2013}],\"total\":3}"
  end
end