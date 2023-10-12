defmodule MediaServer.MovieActionsTest do
  use ExUnit.Case

  setup do
    {:ok, pid} = MediaServer.MovieActions.start_link(%{})
    %{pid: pid}
  end

  test "it should notify on added", %{pid: pid} do
    send(pid, {:added})

    %{:notify_followers => _ref} = :sys.get_state(pid)
  end
end