defmodule MediaServer.MoviesIndexTest do
  use ExUnit.Case

  test "it should have started" do
    {:error, {:already_started, _pid}} = MediaServer.MoviesIndex.start_link([])
  end
end
