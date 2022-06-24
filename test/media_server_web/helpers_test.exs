defmodule MediaServerWeb.HelpersTest do
  use ExUnit.Case

  test "it should reduce poster size" do
    assert MediaServerWeb.Helpers.reduce_size_for_poster_url(
             "https://some.domain.url/t/p/original/somePosterIdentifier.jpg"
           ) === "https://some.domain.url/t/p/w342/somePosterIdentifier.jpg"
  end

  describe "movie subtitles" do
    @path "fixtures/movies/Caminandes Llama Drama (2013)"
    @file_name "Caminandes.Llama.Drama.1080p.mp4"
    @expected ["Caminandes.Llama.Drama.1080p.en.srt", "Caminandes.Llama.Drama.1080p.mp4"]
    @filtered "Caminandes.Llama.Drama.1080p.en.srt"

    test "it gets subtitle" do
      assert File.ls!(@path) == @expected

      assert MediaServerWeb.Helpers.get_subtitle(@path, @file_name) == @filtered
    end

    test "it has subtitle" do
      assert File.ls!(@path) == @expected

      assert MediaServerWeb.Helpers.has_subtitle(@path, @file_name)
    end

    @path_without "fixtures/movies/Caminandes Gran Dillama (2013)"
    @file_name_without "Caminandes.Gran.Dillama.1080p.mp4"
    @expected_without ["Caminandes.Gran.Dillama.1080p.mp4"]
    @filtered_without nil

    test "it does not get subtitle" do
      assert File.ls!(@path_without) == @expected_without

      assert MediaServerWeb.Helpers.get_subtitle(@path_without, @file_name_without) == @filtered_without
    end

    test "it does not have subtitle" do
      assert File.ls!(@path_without) == @expected_without

      refute MediaServerWeb.Helpers.has_subtitle(@path_without, @file_name_without)
    end
  end
end
