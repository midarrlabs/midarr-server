defmodule MediaServerWeb.Components.PageSectionAlternativeComponent do
  use Phoenix.Component

  slot :inner_block

  slot :header, required: false
  slot :footer, required: false

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-7xl lg:px-8">
      <div class="relative px-4 sm:px-8 lg:px-12">
        <div class="mx-auto max-w-2xl lg:max-w-5xl">
          <div class="flex justify-between py-4">
            <%= render_slot(@header) %>
          </div>

          <div class="justify-items-center grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-x-4 gap-y-10 py-4">
            <%= render_slot(@inner_block) %>
          </div>

          <%= render_slot(@footer) %>
        </div>
      </div>
    </div>
    """
  end
end
