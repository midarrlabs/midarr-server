defmodule MediaServerWeb.HelpersTest do
  use ExUnit.Case

  test "it should reduce poster size" do
    assert MediaServerWeb.Helpers.reduce_size_for_poster_url("https://some.domain.url/t/p/original/somePosterIdentifier.jpg") === "https://some.domain.url/t/p/w342/somePosterIdentifier.jpg"
  end
end