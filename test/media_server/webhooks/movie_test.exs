defmodule MediaServer.Webhooks.MovieTest do
  use ExUnit.Case

  alias MediaServerWeb.Repositories.Movies

  test "it should have a notification" do
    assert Enum.count(Movies.get_notification()) === 1
  end
end
