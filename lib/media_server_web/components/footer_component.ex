defmodule MediaServerWeb.Components.FooterComponent do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <footer class="mt-32">
      <div class="sm:px-8">
        <div class="mx-auto max-w-7xl lg:px-8">
          <div class="border-t border-zinc-100 pt-10 pb-16 dark:border-zinc-700/40">
            <div class="relative px-4 sm:px-8 lg:px-12">
              <div class="mx-auto max-w-2xl lg:max-w-5xl">
                <div class="flex flex-col items-center justify-between gap-6 sm:flex-row">
                  <div class="flex gap-6 text-sm font-medium text-zinc-800 dark:text-zinc-200">
                    <a class="transition hover:text-teal-500 dark:hover:text-red-400" href="/about">
                      Movies
                    </a>
                    <a class="transition hover:text-teal-500 dark:hover:text-red-400" href="/projects">
                      Series
                    </a>
                    <a class="transition hover:text-teal-500 dark:hover:text-red-400" href="/speaking">
                      Playlists
                    </a>
                    <a class="transition hover:text-teal-500 dark:hover:text-red-400" href="/uses">
                      Continues
                    </a>
                  </div>
                  <p class="text-sm text-zinc-400 dark:text-zinc-500">
                    © <!-- -->2023<!-- --> Midarr Labs. All rights reserved.
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </footer>
    """
  end
end
