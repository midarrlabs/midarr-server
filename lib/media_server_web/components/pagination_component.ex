defmodule MediaServerWeb.Components.PaginationComponent do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <div class="flex pt-10">
      <%= if assigns.page_number > 1 do %>
        <div class="flex flex-col items-start gap-3">
          <.link
            class="inline-flex gap-0.5 justify-center overflow-hidden text-sm font-medium transition rounded-full bg-zinc-100 py-1 px-3 text-zinc-900 hover:bg-zinc-200 dark:bg-zinc-800/40 dark:text-zinc-400 dark:ring-1 dark:ring-inset dark:ring-zinc-800 dark:hover:bg-zinc-800 dark:hover:text-zinc-300"
            navigate={@previous_link}
          >
            <svg viewBox="0 0 20 20" fill="none" class="mt-0.5 h-5 w-5 -ml-1 rotate-180"><path
                stroke="currentColor"
                stroke-linecap="round"
                stroke-linejoin="round"
                d="m11.5 6.5 3 3.5m0 0-3 3.5m3-3.5h-9"
              ></path></svg>Previous
          </.link>
          <.link
            id="pagination-previous"
            class="text-base font-semibold text-zinc-900 transition hover:text-zinc-600 dark:text-white dark:hover:text-zinc-300"
            navigate={@previous_link}
          >Page <%= @page_number - 1 %></.link>
        </div>
      <% end %>

      <%= if assigns.page_number !== assigns.total_pages do %>
        <div class="ml-auto flex flex-col items-end gap-3">
          <.link
            class="inline-flex gap-0.5 justify-center overflow-hidden text-sm font-medium transition rounded-full bg-zinc-100 py-1 px-3 text-zinc-900 hover:bg-zinc-200 dark:bg-zinc-800/40 dark:text-zinc-400 dark:ring-1 dark:ring-inset dark:ring-zinc-800 dark:hover:bg-zinc-800 dark:hover:text-zinc-300"
            navigate={@next_link}
          >
            Next<svg viewBox="0 0 20 20" fill="none" aria-hidden="true" class="mt-0.5 h-5 w-5 -mr-1"><path
                stroke="currentColor"
                stroke-linecap="round"
                stroke-linejoin="round"
                d="m11.5 6.5 3 3.5m0 0-3 3.5m3-3.5h-9"
              ></path></svg>
          </.link>
          <.link
            id="pagination-next"
            class="text-base font-semibold text-zinc-900 transition hover:text-zinc-600 dark:text-white dark:hover:text-zinc-300"
            navigate={@next_link}
          >Page <%= @page_number + 1 %></.link>
        </div>
      <% end %>
    </div>
    """
  end
end
