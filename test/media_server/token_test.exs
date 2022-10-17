defmodule MediaServer.TokenTest do
  use ExUnit.Case

  alias MediaServer.Token

  test "it should equal token held" do
    {:ok, result} = Phoenix.Token.verify(MediaServerWeb.Endpoint, "user auth", Token.get_token())

    assert result === MediaServer.Token
  end
end
