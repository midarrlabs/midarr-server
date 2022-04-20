defmodule MediaServer.Repositories.MoviesTest do
  use ExUnit.Case

  alias MediaServerWeb.Repositories.Movies
  alias MediaServer.MoviesFixtures

  setup do
    pid = start_supervised!(MediaServer.Repositories.Movies)
    %{pid: pid}
  end

  test "get all", %{pid: pid} do
    movie = Movies.get_all()

    assert MediaServer.Repositories.Movies.get_all(pid) === movie
  end
end
