defmodule MediaServerWeb.Components.PageSectionComponent do
  use Phoenix.Component

  slot :header
  slot(:inner_block, required: true)

  def render(assigns) do
    ~H"""
    <div class="sm:px-8 mt-24 md:mt-28">
      <div class="mx-auto lg:px-8">

      <div class="flex justify-between px-3 py-4">
        <%= render_slot(@header) %>
      </div>

        <div class="mt-6 grid grid-cols-2 gap-x-4 gap-y-10 sm:gap-x-6 md:grid-cols-3 lg:grid-cols-6 lg:gap-x-8 justify-items-center">
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    </div>
    """
  end
end
