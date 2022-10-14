defmodule MediaServerWeb.SubtitleEpisodeControllerTest do
  use MediaServerWeb.ConnCase

  alias MediaServerWeb.Repositories.Series
  alias MediaServerWeb.Repositories.Episodes

  test "episode", %{conn: conn} do
    serie = Series.get_all() |> List.first()

    episode = Episodes.get_episode(serie["id"])

    token = Phoenix.Token.sign(MediaServerWeb.Endpoint, "user auth", "id")

    conn = get(conn, Routes.subtitle_episode_path(conn, :show, episode["id"]), token: token)

    assert conn.status === 200
    assert conn.state === :sent

    assert conn.resp_body ===
             "WEBVTT\n\n00:01:00.400 --> 00:01:15.300\nThis is an example of a subtitle for Pioneer One Season 1 Episode 1.\n\n00:01:16.400 --> 00:01:25.300\nThis is an example of a subtitle\nwith multiple lines."
  end
end
