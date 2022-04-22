defmodule MediaServerWeb.PaginationComponentTest do
  use ExUnit.Case

  import Phoenix.LiveViewTest

  test "it should" do

    assert render_component(MediaServerWeb.Components.PaginationComponent) =~ "Previous"
  end
end