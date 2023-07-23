defmodule MediaServerWeb.Components.PageSectionAlternativeComponent do
  use Phoenix.Component

  slot :header
  slot(:inner_block, required: true)

  def render(assigns) do
    ~H"""
    <div class="sm:px-8 mt-12 md:mt-20">
      <div class="mx-auto lg:px-8">

      <div class="flex justify-between px-3 py-4">
        <%= render_slot(@header) %>
      </div>

      <div class="space-y-12 px-4 py-6">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-x-4 gap-y-10">
          <%= render_slot(@inner_block) %>
        </div>
      </div>

      </div>
    </div>
    """
  end
end
