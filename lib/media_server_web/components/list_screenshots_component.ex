defmodule MediaServerWeb.Components.ListScreenshotsComponent do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <ul class="mt-10">
      <%= for item <- @items do %>
        <li>
          <hr role="presentation" class="w-full border-t border-zinc-950/10 dark:border-white/10" />
          <div class="flex items-center justify-between">
            <div class="flex gap-6 py-6">
              <div class="w-52 shrink-0">
                <.link navigate={"/watch?episode=#{item.sonarr_id}"}>
                  <img class="aspect-[3/2] rounded-lg shadow" src={"/api/images?url=#{Map.get(item, @image)}&type=proxy&token=#{@token}"} alt="" />
                </.link>
              </div>
              <div class="space-y-1.5">
                <div class="text-base/6 font-semibold text-white">
                  <.link navigate={"/watch?episode=#{item.sonarr_id}"}><%= item.title %></.link>
                </div>
                <div class="text-xs/6 text-zinc-500">
                  <%= item.overview %>
                </div>
              </div>
            </div>
          </div>
        </li>
      <% end %>
    </ul>
    """
  end
end
