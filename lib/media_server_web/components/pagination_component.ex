defmodule MediaServerWeb.Components.PaginationComponent do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <nav class="mt-6 py-3 flex items-center justify-between bottom-0 sticky pb-4 dark:bg-zinc-900">
      <div class="hidden sm:block">
        <h2 class="text-sm text-zinc-400 dark:text-zinc-500">
          Showing <%= assigns.page_number %> of <%= assigns.total_pages %> pages
        </h2>
      </div>

      <div class="flex-1 flex justify-between sm:justify-end">
        <div>
          <%= if assigns.page_number > 1 do %>
            <%= live_redirect to: assigns.previous_link, class: "relative inline-flex items-center px-4 py-2 text-sm font-medium rounded-md dark:text-zinc-200 dark:hover:text-red-400" do %>
              Previous
            <% end %>
          <% end %>
        </div>

        <%= if assigns.page_number !== assigns.total_pages do %>
          <%= live_redirect to: assigns.next_link, class: "ml-3 relative inline-flex items-center py-2 text-sm font-medium rounded-md dark:text-zinc-200 dark:hover:text-red-400" do %>
            Next
          <% end %>
        <% end %>
      </div>
    </nav>
    """
  end
end
