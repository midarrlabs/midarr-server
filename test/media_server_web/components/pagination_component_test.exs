defmodule MediaServerWeb.PaginationComponentTest do
  use ExUnit.Case

  import Phoenix.LiveViewTest

  test "it should render" do
    assert render_component(&MediaServerWeb.Components.PaginationComponent.render/1,
             page_number: 1,
             total_pages: 10,
             previous_link: "",
             next_link: ""
           ) =~ "pagination-next"

    assert render_component(&MediaServerWeb.Components.PaginationComponent.render/1,
             page_number: 2,
             total_pages: 10,
             previous_link: "",
             next_link: ""
           ) =~ "pagination-previous"

    refute render_component(&MediaServerWeb.Components.PaginationComponent.render/1,
             page_number: 1,
             total_pages: 10,
             previous_link: "",
             next_link: ""
           ) =~ "pagination-previous"

    assert render_component(&MediaServerWeb.Components.PaginationComponent.render/1,
             page_number: 2,
             total_pages: 10,
             previous_link: "",
             next_link: ""
           ) =~ "pagination-next"

    refute render_component(&MediaServerWeb.Components.PaginationComponent.render/1,
             page_number: 10,
             total_pages: 10,
             previous_link: "",
             next_link: ""
           ) =~ "pagination-next"
  end
end
