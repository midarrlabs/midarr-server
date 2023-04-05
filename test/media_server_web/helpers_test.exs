defmodule MediaServerWeb.HelpersTest do
  use ExUnit.Case

  test "it should reduce poster size" do
    assert MediaServerWeb.Helpers.reduce_size_for_poster_url(
             "https://some.domain.url/t/p/original/somePosterIdentifier.jpg"
           ) === "https://some.domain.url/t/p/w342/somePosterIdentifier.jpg"
  end

  describe "movie subtitles" do
    @movie_path "/library/movies/Caminandes Llama Drama (2013)"
    @movie_file_name "Caminandes.Llama.Drama.1080p.mp4"
    @movie_file_no_extension "Caminandes.Llama.Drama.1080p"
    @movie_srt "Caminandes.Llama.Drama.1080p.en.srt"

    @movie_path_no_srt "/library/movies/Caminandes Gran Dillama (2013)"
    @movie_file_no_srt "Caminandes.Gran.Dillama.1080p.mp4"

    test "it gets subtitle" do
      assert MediaServer.Subtitles.get_subtitle(@movie_path, @movie_file_name) == @movie_srt
    end

    test "it has subtitle" do
      assert MediaServer.Subtitles.has_subtitle(@movie_path, @movie_file_name)
    end

    test "it does not get subtitle" do
      assert MediaServer.Subtitles.get_subtitle(@movie_path_no_srt, @movie_file_no_srt) == nil
    end

    test "it does not have subtitle" do
      refute MediaServer.Subtitles.has_subtitle(@movie_path_no_srt, @movie_file_no_srt)
    end

    test "it removes file extension" do
      assert MediaServer.Subtitles.remove_extension_from(@movie_file_name) ===
               @movie_file_no_extension
    end
  end

  describe "episode subtitles" do
    @season_1 "/library/series/Pioneer One/Season 1"

    @episode_2_full_path "/library/series/Pioneer One/Season 1/Pioneer.One.S01E02.The.Man.From.Mars.720p.mp4"
    @episode_2_relative_path "Season 1/Pioneer.One.S01E02.The.Man.From.Mars.720p.mp4"
    @episode_2_directory "/library/series/Pioneer One/Season 1"
    @episode_2 "Pioneer.One.S01E02.The.Man.From.Mars.720p.mp4"
    @episode_2_srt "Pioneer.One.S01E02.The.Man.From.Mars.720p.en.srt"

    @episode_3 "Pioneer.One.S01E03.Alone.in.the.Night.720p.mp4"

    test "it gets subtitle" do
      assert MediaServer.Subtitles.get_subtitle(@season_1, @episode_2) == @episode_2_srt
    end

    test "it has subtitle" do
      assert MediaServer.Subtitles.has_subtitle(@season_1, @episode_2)
    end

    test "it does not get subtitle" do
      assert MediaServer.Subtitles.get_subtitle(@season_1, @episode_3) == nil
    end

    test "it does not have subtitle" do
      refute MediaServer.Subtitles.has_subtitle(@season_1, @episode_3)
    end

    test "it gets file name" do
      assert MediaServer.Subtitles.get_file_name(@episode_2_full_path) === @episode_2
      assert MediaServer.Subtitles.get_file_name(@episode_2_relative_path) === @episode_2
    end

    test "it gets parent path" do
      assert MediaServer.Subtitles.get_parent_path(@episode_2_full_path) === @episode_2_directory
    end
  end
end
