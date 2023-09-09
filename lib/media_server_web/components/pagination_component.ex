defmodule MediaServerWeb.Components.PaginationComponent do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
          <div class="flex">
            <div class="ml-auto flex flex-col items-end gap-3">
              <a
                class="inline-flex gap-0.5 justify-center overflow-hidden text-sm font-medium transition rounded-full bg-zinc-100 py-1 px-3 text-zinc-900 hover:bg-zinc-200 dark:bg-zinc-800/40 dark:text-zinc-400 dark:ring-1 dark:ring-inset dark:ring-zinc-800 dark:hover:bg-zinc-800 dark:hover:text-zinc-300"
                aria-label="Next: Quickstart"
                href="/quickstart"
              >
                Next<svg
                  viewBox="0 0 20 20"
                  fill="none"
                  aria-hidden="true"
                  class="mt-0.5 h-5 w-5 -mr-1"
                ><path
                    stroke="currentColor"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="m11.5 6.5 3 3.5m0 0-3 3.5m3-3.5h-9"
                  ></path></svg>
              </a>
              <a
                tabindex="-1"
                aria-hidden="true"
                class="text-base font-semibold text-zinc-900 transition hover:text-zinc-600 dark:text-white dark:hover:text-zinc-300"
                href="/quickstart"
              >
                Quickstart
              </a>
            </div>
          </div>
    """
  end
end
