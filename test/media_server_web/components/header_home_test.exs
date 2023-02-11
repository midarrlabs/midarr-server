defmodule MediaServerWeb.HeaderHomeTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  @movies MediaServer.MoviesIndex.get_latest(3)
  @movie @movies |> List.first()
  @movie_without_images @movie |> Map.delete("images")
  @without_movies []

  test "it should render", %{conn: conn} do
    assert render_component(&MediaServerWeb.Components.HeaderHome.render/1,
             socket: conn,
             movies: @movies
           ) =~ @movie["title"]
  end

  test "it should render without images", %{conn: conn} do
    assert render_component(&MediaServerWeb.Components.HeaderHome.render/1,
             socket: conn,
             movies: [@movie_without_images]
           ) =~ "background-image: url()"
  end

  test "it should render without movie", %{conn: conn} do
    assert render_component(&MediaServerWeb.Components.HeaderHome.render/1,
             socket: conn,
             movies: @without_movies
           ) =~ "No movies found. Please add movies to show here."
  end
end
