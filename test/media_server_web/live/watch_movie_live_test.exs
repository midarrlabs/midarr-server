defmodule MediaServerWeb.WatchMovieLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest
  import Ecto.Query

  setup %{conn: conn} do
    movie = MediaServer.Repo.get_by(MediaServer.Movies, id: 1)

    %{conn: conn |> log_in_user(MediaServer.AccountsFixtures.user_fixture()), movie: movie}
  end

  test "it should continue", %{conn: conn, movie: movie} do
    {:ok, view, _disconnected_html} = live(conn, ~p"/watch?movie=#{movie.id}")

    render_hook(view, :video_destroyed, %{
      current_time: 89,
      duration: 100
    })

    query =
      from m in MediaServer.Movies,
        where: m.id == ^movie.id

    result = MediaServer.Repo.one(query)

    assert MediaServer.MovieContinues.where(movies_id: result.id).current_time === 89

    {:ok, view, _disconnected_html} = live(conn, ~p"/watch?movie=#{movie.id}&timestamp=89")

    assert render(view) =~ "89"

    render_hook(view, :video_destroyed, %{
      current_time: 45,
      duration: 100
    })

    query =
      from m in MediaServer.Movies,
        where: m.id == ^movie.id

    result = MediaServer.Repo.one(query)

    assert MediaServer.MovieContinues.where(movies_id: result.id).current_time === 45
  end

  test "it should not have navigation", %{conn: conn} do
    movie = MediaServer.MoviesIndex.find(MediaServer.MoviesIndex.all(), "2")

    {:ok, _view, disconnected_html} =
      live(conn, Routes.watch_index_path(conn, :index, movie: movie["id"]))

    refute disconnected_html =~ "mobile-menu"
  end
end
