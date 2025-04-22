defmodule MediaServerWeb.Components.ListPostersComponent do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <ul role="list" class="mt-10 grid grid-cols-2 md:grid-cols-7 gap-x-4 gap-y-8">
      <%= for item <- @items do %>
        <.link navigate={"/#{@id}/#{item.id}"}>
          <li class="relative">
            <div class="group aspect-h-7 aspect-w-10 block w-full overflow-hidden rounded-lg bg-gray-100 focus-within:ring-2 focus-within:ring-indigo-500 focus-within:ring-offset-2 focus-within:ring-offset-gray-100">
              <img
                src={"/api/images?url=#{Map.get(item, @image)}&token=#{@token}"}
                 alt={"#{Map.get(item, :name, Map.get(item, :title))}"}
                class="pointer-events-none object-cover group-hover:opacity-75"
              />
            </div>
          </li>
        </.link>
      <% end %>
    </ul>
    """
  end
end
