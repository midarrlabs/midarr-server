defmodule MediaServerWeb.Components.PageHeaderComponent do
  use Phoenix.Component

  attr :title, :string, required: true
  attr :description, :string, default: nil

  def render(assigns) do
    ~H"""
    <div class="sm:px-8 mt-16 sm:mt-32">
      <div class="mx-auto max-w-7xl lg:px-8">
        <div class="relative px-4 sm:px-8 lg:px-12">
          <div class="mx-auto max-w-2xl lg:max-w-5xl">
            <div class="grid grid-cols-1 gap-y-16 lg:grid-cols-2 lg:grid-rows-[auto_1fr] lg:gap-y-12">
              <div class="lg:order-first lg:row-span-2">
                <h1 class="text-4xl font-bold tracking-tight text-zinc-800 dark:text-zinc-100 sm:text-5xl">
                  <%= @title %>
                </h1>
                <div class="mt-6 text-base text-zinc-600 dark:text-zinc-200 line-clamp-2">
                  <%= @description %>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
