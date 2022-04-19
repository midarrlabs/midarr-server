defmodule MediaServer.Repositories.MoviesTest do
  use ExUnit.Case

  setup do
    repository = start_supervised!(MediaServer.Repositories.Movies)
    %{repository: repository}
  end

  test "it should", %{repository: repository} do
    assert true
  end
end