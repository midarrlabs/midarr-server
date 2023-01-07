defmodule MediaServer.MoviesIndexTest do
  use ExUnit.Case

  @some_movie %{
    "images" => [
      %{
        "coverType" => "banner",
        "remoteUrl" => "https://some.remote.url/some-banner"
      },
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

  @some_movie_without_poster %{
    "images" => [
      %{
        "coverType" => "banner",
        "remoteUrl" => "https://some.remote.url/some-banner"
      },
      %{
        "coverType" => "headshot",
        "remoteUrl" => "https://some.remote.url/some-headshot"
      }
    ]
  }

  test "it should get poster" do
    assert MediaServer.MoviesIndex.get_poster(@some_movie) === "https://some.remote.url/some-poster"
  end

  test "it should get empty string without poster" do
    assert MediaServer.MoviesIndex.get_poster(@some_movie_without_poster) === ""
  end

  test "it should get empty string without images" do
    assert MediaServer.MoviesIndex.get_poster(%{}) === ""
  end
end