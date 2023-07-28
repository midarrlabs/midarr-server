defmodule MediaServer.SeriesIndexTest do
  use ExUnit.Case
  
  test "it should have started" do
    {:error, {:already_started, _pid}} = MediaServer.SeriesIndex.start_link([])
  end
end
