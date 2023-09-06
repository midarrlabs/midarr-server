defmodule MediaServer.ApplicationTest do
  use ExUnit.Case

  test "it should have started" do
    {:error, {:already_started, _pid}} = MediaServer.Application.start(:ok, [])
  end

  test "it should config change" do
    changed = [key: "value"]
    removed = [:key_to_remove]

    result = MediaServer.Application.config_change(changed, nil, removed)

    assert result == :ok
  end
end
