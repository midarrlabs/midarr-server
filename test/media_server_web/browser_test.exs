defmodule MediaServerWeb.BrowserTest do
  use MediaServerWeb.ConnCase
  use Wallaby.Feature

  feature "test", %{session: session} do
    session
    |> visit("/")
    |> assert_has(Query.text("Login to your account"))
  end
end