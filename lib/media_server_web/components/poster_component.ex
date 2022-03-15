defmodule MediaServerWeb.Components.PosterComponent do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <div class="group relative">

    <div class="w-full bg-gray-200 aspect-[4/6] rounded-md overflow-hidden group-hover:opacity-75 lg:aspect-none">
      <img class="h-full object-cover" src={assigns.img_src}>
    </div>

    <div class="mt-2 flex">
      <h3 class="text-sm text-slate-600">
         <%= live_redirect to: assigns.link, class: "hover:text-slate-800 hover:underline" do %>
            <span aria-hidden="true" class="absolute inset-0"></span>
            <%= assigns.title %>
         <% end %>
      </h3>
    </div>
    </div>
    """
  end
end
