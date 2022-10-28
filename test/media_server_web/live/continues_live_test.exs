defmodule MediaServerWeb.ContinuesLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures

  setup %{conn: conn} do
    user = AccountsFixtures.user_fixture()

    %{conn: conn |> log_in_user(user), user: user}
  end

  test "it should render", %{conn: conn, user: _user} do
    assert html_response(get(conn, Routes.continues_index_path(conn, :index)), 200)
  end

  test "it should delete", %{conn: conn, user: user} do
    {:ok, %MediaServer.MediaTypes{} = mediaType} =
      MediaServer.MediaTypes.create(%{type: "some type"})

    {:ok, %MediaServer.Media{} = media} =
      MediaServer.Media.create(%{media_id: 123, media_type_id: mediaType.id})

    {:ok, continue} =
      MediaServer.Continues.create(%{
        current_time: 42,
        duration: 84,
        user_id: user.id,
        media_id: media.id
      })

    {:ok, index_live, _html} = live(conn, Routes.continues_index_path(conn, :index))

    assert index_live |> element("#media-#{continue.id}") |> render_click()
  end
end
