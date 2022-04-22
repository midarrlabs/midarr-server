defmodule MediaServerWeb.PaginationComponentTest do
  use ExUnit.Case

  import Phoenix.LiveViewTest

  test "it should" do

    assert render_component(&MediaServerWeb.Components.PaginationComponent.render/1, page_number: 1, total_pages: 10) =~ "1</span>\n      of"
    assert render_component(&MediaServerWeb.Components.PaginationComponent.render/1, page_number: 1, total_pages: 10) =~ "10</span>\n      pages"
  end
end