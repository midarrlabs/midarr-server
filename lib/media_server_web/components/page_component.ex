defmodule MediaServerWeb.Components.PageComponent do
  use Phoenix.Component

  slot :inner_block

  def render(assigns) do
    ~H"""
    <div class="relative mx-auto flex w-full max-w-8xl flex-auto justify-center sm:px-2 lg:px-8 xl:px-12">

      <.live_component module={MediaServerWeb.Components.SideBarComponent} id="side-bar-component" />

      <div class="min-w-0 max-w-2xl flex-auto px-4 py-16 lg:max-w-none lg:pl-8 lg:pr-0 xl:px-16">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end
end
