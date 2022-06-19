defmodule MediaServer.ExtitleTest do
  use ExUnit.Case

  alias MediaServer.Extitle

  @srt_path "test/support/fixtures/example.srt"
  @read_result "1\n00:05:00,400 --> 00:05:15,300\nThis is an example of\na subtitle.\n\n2\n00:05:16,400 --> 00:05:25,300\nThis is an example of\na subtitle - 2nd subtitle."

  @expected [
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
    assert File.read!(@srt_path) == @read_result
    assert Extitle.parse(@srt_path) == @expected
  end
end
