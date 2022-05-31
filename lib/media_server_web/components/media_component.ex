defmodule MediaServerWeb.Components.MediaComponent do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <div class="group relative">

      <div class="w-full bg-gray-200 aspect-[4/6] rounded-sm overflow-hidden group-hover:opacity-75 lg:aspect-none">
        <img class="h-full object-cover" src={MediaServerWeb.Helpers.reduce_size_for_poster_url(assigns.img_src)} loading="lazy">
      </div>

      <div class="mt-2 flex">
        <h3 class="text-sm text-slate-600 capitalize">
           <a href={MediaServerWeb.Helpers.reduce_size_for_poster_url(assigns.link)} target="_blank" class="hover:text-slate-800 hover:underline">
              <span aria-hidden="true" class="absolute inset-0"></span>
              <%= assigns.title %>
           </a>
        </h3>
      </div>
    </div>
    """
  end
end
