defmodule MediaServerWeb.BrowserTest do
  use ExUnit.Case
  use Wallaby.Feature

  feature "test", %{session: session} do

    session
    |> visit("/")
    |> assert_has(Query.text("Login to your account"))
    |> find(Query.css(".space-y-6"))
    |> fill_in(Query.text_field("user[email]"), with: "admin@email.com")
    |> fill_in(Query.text_field("user[password]"), with: "passwordpassword")
    |> click(Query.button("Login"))

#    timeout
#    session take screenshot
  end
end