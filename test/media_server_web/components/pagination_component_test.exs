defmodule MediaServerWeb.PaginationComponentTest do
  use ExUnit.Case

  import Phoenix.LiveViewTest

  test "it should render" do
    assert render_component(&MediaServerWeb.Components.PaginationComponent.render/1,
             page_number: 1,
             total_pages: 10,
             previous_link: "",
             next_link: ""
           ) =~ "1 of 10"

    assert render_component(&MediaServerWeb.Components.PaginationComponent.render/1,
             page_number: 2,
             total_pages: 10,
             previous_link: "",
             next_link: ""
           ) =~ "Previous"

    refute render_component(&MediaServerWeb.Components.PaginationComponent.render/1,
             page_number: 1,
             total_pages: 10,
             previous_link: "",
             next_link: ""
           ) =~ "Previous"

    assert render_component(&MediaServerWeb.Components.PaginationComponent.render/1,
             page_number: 2,
             total_pages: 10,
             previous_link: "",
             next_link: ""
           ) =~ "Next"

    refute render_component(&MediaServerWeb.Components.PaginationComponent.render/1,
             page_number: 10,
             total_pages: 10,
             previous_link: "",
             next_link: ""
           ) =~ "Next"
  end
end
