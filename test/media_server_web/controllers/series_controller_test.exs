defmodule MediaServerWeb.SeriesControllerTest do
  use MediaServerWeb.ConnCase

  use Plug.Test

  setup do
    %{user: MediaServer.AccountsFixtures.user_fixture()}
  end

  test "it should have all", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/series?token=#{user.api_token.token}")

    assert conn.status === 200

    assert conn.resp_body === "{\"items\":[{\"background\":\"/api/images?series=1&type=background\",\"id\":1,\"overview\":\"An object in the sky spreads radiation over North America. Fearing terrorism, U.S. Homeland Security agents are dispatched to investigate and contain the damage. What they discover will have implications for the entire world.\",\"poster\":\"/api/images?series=1&type=poster\",\"title\":\"Pioneer One\",\"year\":2010}],\"next_page\":\"/api/series?page=2\",\"prev_page\":\"/api/series?page=0\",\"total\":1}"
  end

  test "it should have all paged", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/series?page=1&token=#{user.api_token.token}")

    assert conn.status === 200

    assert conn.resp_body === "{\"items\":[{\"background\":\"/api/images?series=1&type=background\",\"id\":1,\"overview\":\"An object in the sky spreads radiation over North America. Fearing terrorism, U.S. Homeland Security agents are dispatched to investigate and contain the damage. What they discover will have implications for the entire world.\",\"poster\":\"/api/images?series=1&type=poster\",\"title\":\"Pioneer One\",\"year\":2010}],\"next_page\":\"/api/series?page=2\",\"prev_page\":\"/api/series?page=0\",\"total\":1}"
  end

  test "it should NOT have all paged", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/series?page=2&token=#{user.api_token.token}")

    assert conn.status === 200

    assert conn.resp_body ===
             "{\"items\":[],\"next_page\":\"/api/series?page=3\",\"prev_page\":\"/api/series?page=1\",\"total\":1}"
  end

  test "it should have id", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/series/1?token=#{user.api_token.token}")

    assert conn.status === 200

    assert conn.resp_body === "{\"background\":\"/api/images?series=1&type=background\",\"id\":1,\"overview\":\"An object in the sky spreads radiation over North America. Fearing terrorism, U.S. Homeland Security agents are dispatched to investigate and contain the damage. What they discover will have implications for the entire world.\",\"poster\":\"/api/images?series=1&type=poster\",\"seasonCount\":1,\"title\":\"Pioneer One\",\"year\":2010}"
  end

  test "it should have season", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/series/1?season=1&token=#{user.api_token.token}")

    assert conn.status === 200

    assert conn.resp_body === "[{\"overview\":\"An object from space spreads radiation over North America. Fearing terrorism, U.S. Homeland Security agents are dispatched to investigate and contain the damage. What they discover is a forgotten relic of the old Soviet space program, whose return to Earth will have implications for the entire world.\",\"screenshot\":\"/api/images?episode=1&type=screenshot\",\"stream\":\"/api/playlist.m3u8?episode=1\",\"title\":\"Earthfall\"},{\"overview\":\"Hired Mars expert Dr. Zachary Walzer (Jack Haley) fights to prove the validity of the Mars story. Can he convince the government to mount a manned mission to Mars? Agent in charge Tom Taylor (James Rich) faces pressure from both the Canadians and his own superiors, and has to make a call.\",\"screenshot\":\"/api/images?episode=2&type=screenshot\",\"stream\":\"/api/playlist.m3u8?episode=2\",\"title\":\"The Man From Mars\"},{\"overview\":\"Now quarantined to the Calgary base for two weeks, Taylor and his team have bought time to get answers from the supposed Martian cosmonaut. But who can get him to talk?\",\"screenshot\":\"/api/images?episode=3&type=screenshot\",\"stream\":\"/api/playlist.m3u8?episode=3\",\"title\":\"Alone in the Night\"},{\"overview\":\"As the media begins to question the story about the crashed satellite, Secretary McClellan (Einar Gunn) starts to play hardball with the Russians in pursuit of his own truth. But everything hinges on what Yuri (Aleksandr Evtushenko), the frightened boy at the center of it all, might have to say...\",\"screenshot\":\"/api/images?episode=4&type=screenshot\",\"stream\":\"/api/playlist.m3u8?episode=4\",\"title\":\"Triangular Diplomacy\"},{\"overview\":\"When an unannounced visitor breaks in to the Calgary base with just days left in the Quarantine, tensions are higher than ever. The fate of Yuri and everyone on Tom Taylor’s team is about to be decided in this, the penultimate episode of the first season.\",\"screenshot\":\"/api/images?episode=5&type=screenshot\",\"stream\":\"/api/playlist.m3u8?episode=5\",\"title\":\"Sea Change\"},{\"overview\":\"Taylor prepares to go to the public with Yuri's story, and everyone discovers the consequences of their actions in the conclusion to Pioneer One's first season.\",\"screenshot\":\"/api/images?episode=6&type=screenshot\",\"stream\":\"/api/playlist.m3u8?episode=6\",\"title\":\"War of the World\"}]"
  end
end
