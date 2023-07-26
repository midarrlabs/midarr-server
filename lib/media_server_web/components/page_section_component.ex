defmodule MediaServerWeb.Components.PageSectionComponent do
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

            <div role="list" class="grid grid-cols-2 gap-x-4 gap-y-8 sm:grid-cols-3 sm:gap-x-6 lg:grid-cols-5 xl:gap-x-8 py-4">
              <%= render_slot(@inner_block) %>
            </div>

            <%= render_slot(@footer) %>
          </div>
        </div>
      </div>
    """
  end
end
