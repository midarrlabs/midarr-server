defmodule MediaServerWeb.HelpersTest do
  use ExUnit.Case

  test "it should reduce poster size" do
    assert MediaServerWeb.Helpers.reduce_size_for_poster_url(
             "https://some.domain.url/t/p/original/somePosterIdentifier.jpg"
           ) === "https://some.domain.url/t/p/w342/somePosterIdentifier.jpg"
  end

  @path "fixtures/movies/Caminandes Llama Drama (2013)"
  @expected [".DS_Store", "Caminandes.Llama.Drama.1080p.mp4", "Caminandes.Llama.Drama.1080p.srt"]
  @filtered "Caminandes.Llama.Drama.1080p.srt"

  test "it should get subtitle" do
    assert File.ls!(@path) == @expected

    assert MediaServerWeb.Helpers.get_subtitle(@path) == @filtered
  end

  test "it has subtitle" do
    assert File.ls!(@path) == @expected

    assert MediaServerWeb.Helpers.has_subtitle(@path)
  end

  @path_without "fixtures/movies/Caminandes Gran Dillama (2013)"
  @expected_without [".DS_Store", "Caminandes.Gran.Dillama.1080p.mp4"]
  @filtered_without nil

  test "it should not get subtitle" do
    assert File.ls!(@path_without) == @expected_without

    assert MediaServerWeb.Helpers.get_subtitle(@path_without) == @filtered_without
  end

  test "it does not have subtitle" do
    assert File.ls!(@path_without) == @expected_without

    refute MediaServerWeb.Helpers.has_subtitle(@path_without)
  end
end
