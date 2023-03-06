defmodule MediaServerWeb.Components.PaginationComponent do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
      <div class="flex-1 flex items-center justify-end">
        <div>
          <%= if assigns.page_number > 1 do %>
            <%= live_redirect to: assigns.previous_link, class: "relative inline-flex px-2 items-center text-base font-semibold text-zinc-800 dark:text-zinc-100 dark:hover:text-red-400" do %>
              Previous
            <% end %>
          <% end %>
        </div>

        <%= if assigns.page_number !== assigns.total_pages do %>
          <%= live_redirect to: assigns.next_link, class: "ml-3 relative inline-flex px-2 items-center text-base font-semibold text-zinc-800 dark:text-zinc-100 dark:hover:text-red-400" do %>
            Next
          <% end %>
        <% end %>
      </div>
    """
  end
end
