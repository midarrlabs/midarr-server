defmodule MediaServerWeb.Components.CardComponent do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <%= live_redirect to: assigns.link do %>
      <div class={"w-#{ assigns.width }"}>
        <div class="relative">
          <div class="relative">
            <img loading="lazy" class="object-cover m-0" alt={assigns.title} src={assigns.img_src} />
          </div>

          <div class="absolute inset-x-0 top-0 flex h-full items-end justify-end">
            <div
              aria-hidden="true"
              class="absolute inset-x-0 bottom-0 h-36 bg-gradient-to-t from-black opacity-50"
            >
            </div>
            <div class="relative text-xs font-semibold text-white bg-black text-center rounded-lg mb-2 mr-1">
              <span class="p-2">
                <%= assigns.runtime %>
              </span>
            </div>
          </div>
        </div>

        <div class="relative flex space-x-2">
          <div class="mt-4">
            <p class="text-sm font-medium text-zinc-100 m-0">
              <%= assigns.title %>
            </p>

            <p class="mt-1 text-xs text-zinc-400">
              <%= assigns.subtitle %>
            </p>
          </div>
        </div>
      </div>
    <% end %>
    """
  end
end
