defmodule MediaServer.MoviesIndexTest do
  use MediaServer.DataCase

  test "it should have started" do
    {:error, {:already_started, _pid}} = MediaServer.MoviesIndex.start_link([])
  end
end
