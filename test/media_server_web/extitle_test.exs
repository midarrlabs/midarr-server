defmodule MediaServer.ExtitleTest do
  use MediaServerWeb.ConnCase

  alias MediaServer.Extitle

  @srt_path "test/support/fixtures/example.srt"
  @srt_read "1\n00:05:00,400 --> 00:05:15,300\nThis is an example of\na subtitle.\n\n2\n00:05:16,400 --> 00:05:25,300\nThis is an example of\na subtitle - 2nd subtitle."

  @vtt_path "test/support/fixtures/example.vtt"
  @vtt_read "WEBVTT\n\n00:05:00.400 --> 00:05:15.300\nThis is an example of\na subtitle.\n\n00:05:16.400 --> 00:05:25.300\nThis is an example of\na subtitle - 2nd subtitle."

  @parsed [
    %{
      from: ~T[00:05:00.400],
      to: ~T[00:05:15.300],
      text: [
        "This is an example of",
        "a subtitle."
      ]
    },
    %{
      from: ~T[00:05:16.400],
      to: ~T[00:05:25.300],
      text: [
        "This is an example of",
        "a subtitle - 2nd subtitle."
      ]
    }
  ]

  test "it should parse .srt" do
    assert File.read!(@srt_path) == @srt_read
    assert Extitle.parse(@srt_path) == @parsed
  end

  test "it should format .vtt" do
    assert File.read!(@vtt_path) == @vtt_read
    assert Extitle.format(Extitle.parse(@srt_path)) == @vtt_read
  end
end
