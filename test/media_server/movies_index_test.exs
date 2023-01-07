defmodule MediaServer.MoviesIndexTest do
  use ExUnit.Case

  @some_movie %{
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

  @some_movie_without_poster %{
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

  @some_movie_without_fanart %{
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

  @some_movie_without_headshot %{
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
    assert MediaServer.MoviesIndex.get_poster(%{}) === ""
  end

  test "it should get poster" do
    assert MediaServer.MoviesIndex.get_poster(@some_movie) === "https://some.remote.url/some-poster"
  end

  test "it should get empty string without poster" do
    assert MediaServer.MoviesIndex.get_poster(@some_movie_without_poster) === ""
  end

  test "it should get background" do
    assert MediaServer.MoviesIndex.get_background(@some_movie) === "https://some.remote.url/some-fanart"
  end

  test "it should get empty string without background" do
    assert MediaServer.MoviesIndex.get_background(@some_movie_without_fanart) === ""
  end

  test "it should get headshot" do
    assert MediaServer.MoviesIndex.get_headshot(@some_movie) === "https://some.remote.url/some-headshot"
  end

  test "it should get empty string without headshot" do
    assert MediaServer.MoviesIndex.get_headshot(@some_movie_without_headshot) === ""
  end
end