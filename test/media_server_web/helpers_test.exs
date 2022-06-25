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
    @filtered "Caminandes.Llama.Drama.1080p.en.srt"

    test "it gets subtitle" do
      assert MediaServerWeb.Helpers.get_subtitle(@path, @file_name) == @filtered
    end

    test "it has subtitle" do
      assert MediaServerWeb.Helpers.has_subtitle(@path, @file_name)
    end

    @path_without "fixtures/movies/Caminandes Gran Dillama (2013)"
    @file_name_without "Caminandes.Gran.Dillama.1080p.mp4"
    @filtered_without nil

    test "it does not get subtitle" do
      assert MediaServerWeb.Helpers.get_subtitle(@path_without, @file_name_without) == @filtered_without
    end

    test "it does not have subtitle" do
      refute MediaServerWeb.Helpers.has_subtitle(@path_without, @file_name_without)
    end
  end

  describe "episode subtitles" do
    @path "fixtures/shows/Pioneer One/Season 1"
    @file_name "Pioneer.One.S01E02.The.Man.From.Mars.720p.mp4"
    @filtered "Pioneer.One.S01E02.The.Man.From.Mars.720p.en.srt"

    test "it gets subtitle" do
      assert MediaServerWeb.Helpers.get_subtitle(@path, @file_name) == @filtered
    end

    test "it has subtitle" do
      assert MediaServerWeb.Helpers.has_subtitle(@path, @file_name)
    end
  end

  @file_name_with_extension "Caminandes.Llama.Drama.1080p.mp4"
  @file_name_without_extension "Caminandes.Llama.Drama.1080p"

  test "it removes file extension" do
    assert MediaServerWeb.Helpers.remove_extension_from(@file_name_with_extension) === @file_name_without_extension
  end

  @episode_path "/shows/Pioneer One/Season 1/Pioneer.One.S01E02.The.Man.From.Mars.720p.mp4"
  @episode_relative_path "Season 1/Pioneer.One.S01E02.The.Man.From.Mars.720p.mp4"
  @episode_expected "Pioneer.One.S01E02.The.Man.From.Mars.720p.mp4"
  @season_path_expected "/shows/Pioneer One/Season 1"

  test "it gets file name" do
    assert MediaServerWeb.Helpers.get_file_name(@episode_path) === @episode_expected
    assert MediaServerWeb.Helpers.get_file_name(@episode_relative_path) === @episode_expected
  end

  test "it gets parent path" do
    assert MediaServerWeb.Helpers.get_parent_path(@episode_path) === @season_path_expected
  end
end
