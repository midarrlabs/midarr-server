defmodule MediaServer.HelpersTest do
  use ExUnit.Case

  @some_media %{
    "images" => [
      %{
        "coverType" => "poster",
        "remoteUrl" => "https://some.remote.url/some-poster"
      },
      %{
        "coverType" => "fanart",
        "remoteUrl" => "https://some.remote.url/some-fanart"
      },
      %{
        "coverType" => "headshot",
        "url" => "https://some.remote.url/some-headshot"
      }
    ]
  }

  @some_media_without_poster %{
    "images" => [
      %{
        "coverType" => "fanart",
        "remoteUrl" => "https://some.remote.url/some-fanart"
      },
      %{
        "coverType" => "headshot",
        "remoteUrl" => "https://some.remote.url/some-headshot"
      }
    ]
  }

  @some_media_without_fanart %{
    "images" => [
      %{
        "coverType" => "poster",
        "remoteUrl" => "https://some.remote.url/some-poster"
      },
      %{
        "coverType" => "headshot",
        "remoteUrl" => "https://some.remote.url/some-headshot"
      }
    ]
  }

  @some_media_without_headshot %{
    "images" => [
      %{
        "coverType" => "poster",
        "remoteUrl" => "https://some.remote.url/some-poster"
      },
      %{
        "coverType" => "fanart",
        "remoteUrl" => "https://some.remote.url/some-fanart"
      }
    ]
  }

  test "it should get empty string without images" do
    assert MediaServer.Helpers.get_poster(%{}) === ""
  end

  test "it should get poster" do
    assert MediaServer.Helpers.get_poster(@some_media) === "https://some.remote.url/some-poster"
  end

  test "it should get empty string without poster" do
    assert MediaServer.Helpers.get_poster(@some_media_without_poster) === ""
  end

  test "it should get background" do
    assert MediaServer.Helpers.get_background(@some_media) ===
             "https://some.remote.url/some-fanart"
  end

  test "it should get empty string without background" do
    assert MediaServer.Helpers.get_background(@some_media_without_fanart) === ""
  end

  test "it should get headshot" do
    assert MediaServer.Helpers.get_headshot(@some_media) ===
             "https://some.remote.url/some-headshot"
  end

  test "it should get empty string without headshot" do
    assert MediaServer.Helpers.get_headshot(@some_media_without_headshot) === ""
  end

  test "it should get movie poster file" do
    assert MediaServer.Helpers.get_image_file("https://image.tmdb.org/t/p/original/66VPke0YSiyfe97aobbcZ55ts56.jpg") === "66VPke0YSiyfe97aobbcZ55ts56.jpg"
  end

  test "it should get movie background file" do
    assert MediaServer.Helpers.get_image_file("https://image.tmdb.org/t/p/original/mjkoC8Vo7fSHuqrbVQdI6cNwKA2.jpg") === "mjkoC8Vo7fSHuqrbVQdI6cNwKA2.jpg"
  end

  test "it should get series poster file" do
    assert MediaServer.Helpers.get_image_file("https://artworks.thetvdb.com/banners/posters/170551-1.jpg") === "170551-1.jpg"
  end
end
