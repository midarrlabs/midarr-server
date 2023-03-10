defmodule MediaServerWeb.Components.PageSectionComponent do
  use Phoenix.Component

  slot(:inner_block, required: true)

  def render(assigns) do
    ~H"""
    <div class="mt-6 grid grid-cols-2 gap-x-4 gap-y-10 sm:gap-x-6 md:grid-cols-3 lg:grid-cols-6 lg:gap-x-8 justify-items-center">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
