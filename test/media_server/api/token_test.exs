defmodule MediaServer.Api.TokenTest do
  use ExUnit.Case

  alias MediaServer.Api.Token

  test "it should verify" do
    {:ok, result} = Phoenix.Token.verify(MediaServerWeb.Endpoint, "user auth", Token.get_token())

    assert result === MediaServer.Api.Token
  end
end
