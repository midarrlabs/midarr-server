defmodule MediaServerWeb.Components.PosterLoadingComponent do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <div class="group relative">
      <div class="animate-pulse w-full bg-gray-200 aspect-[4/6] rounded-sm overflow-hidden group-hover:opacity-75 lg:aspect-none">
      </div>

      <div class="mt-2 flex">
        <p class="bg-gray-200 h-6 w-52 rounded"></p>
      </div>
    </div>
    """
  end
end
