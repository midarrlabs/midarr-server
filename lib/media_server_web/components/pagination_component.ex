defmodule MediaServerWeb.Components.PaginationComponent do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <header class="b-16 pb-6 mt-6 z-10 relative flex flex-col bottom-0 sticky">
        <div class="w-full">
          <div class="mx-auto">
            <div class="relative px-4 sm:px-8 lg:px-12">
              <div class="mx-auto">
                <div class="relative flex gap-4">
                  <div class="flex flex-1 justify-end md:justify-center"></div>
                  <div class="flex justify-end md:flex-1">
                    <div class="pointer-events-auto">
                      <ul class="space-x-4 flex rounded-full px-3 text-sm font-medium shadow-lg shadow-zinc-800/5 ring-1 backdrop-blur bg-zinc-800/90 text-zinc-200 ring-white/10">
                        <li>
                          <%= if assigns.page_number > 1 do %>
                            <%= live_redirect id: "pagination-previous", to: assigns.previous_link, class: "flex items-center text-sm py-2 transition hover:text-red-400" do %>
                              <svg
                                fill="none"
                                viewBox="0 0 24 24"
                                stroke-width="1.5"
                                stroke="currentColor"
                                class="w-6 h-6"
                              >
                                <path
                                  stroke-linecap="round"
                                  stroke-linejoin="round"
                                  d="M19.5 12h-15m0 0l6.75 6.75M4.5 12l6.75-6.75"
                                />
                              </svg>
                            <% end %>
                          <% else %>
                            <div class="flex items-center text-sm py-2 transition text-gray-500">
                              <svg
                                fill="none"
                                viewBox="0 0 24 24"
                                stroke-width="1.5"
                                stroke="currentColor"
                                class="w-6 h-6"
                              >
                                <path
                                  stroke-linecap="round"
                                  stroke-linejoin="round"
                                  d="M19.5 12h-15m0 0l6.75 6.75M4.5 12l6.75-6.75"
                                />
                              </svg>
                            </div>
                          <% end %>
                        </li>
                        <li>
                          <%= if assigns.page_number !== assigns.total_pages do %>
                            <%= live_redirect id: "pagination-next", to: assigns.next_link, class: "flex items-center text-sm py-2 transition hover:text-red-400" do %>
                              <svg
                                fill="none"
                                viewBox="0 0 24 24"
                                stroke-width="1.5"
                                stroke="currentColor"
                                class="w-6 h-6"
                              >
                                <path
                                  stroke-linecap="round"
                                  stroke-linejoin="round"
                                  d="M4.5 12h15m0 0l-6.75-6.75M19.5 12l-6.75 6.75"
                                />
                              </svg>
                            <% end %>
                          <% else %>
                            <div class="flex items-center text-sm py-2 transition text-gray-500">
                              <svg
                                fill="none"
                                viewBox="0 0 24 24"
                                stroke-width="1.5"
                                stroke="currentColor"
                                class="w-6 h-6"
                              >
                                <path
                                  stroke-linecap="round"
                                  stroke-linejoin="round"
                                  d="M4.5 12h15m0 0l-6.75-6.75M19.5 12l-6.75 6.75"
                                />
                              </svg>
                            </div>
                          <% end %>
                        </li>
                      </ul>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
    </header>
    """
  end
end
