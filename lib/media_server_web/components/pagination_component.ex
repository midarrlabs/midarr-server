defmodule MediaServerWeb.Components.PaginationComponent do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <nav class="bg-gray-50 mt-12 py-3 flex items-center justify-between border-t border-gray-200 bottom-0 sticky pb-4">
      <div class="hidden sm:block">
        <p class="text-sm text-gray-700">
          Showing <span class="font-medium"><%= assigns.page_number %></span> of
          <span class="font-medium"><%= assigns.total_pages %></span> pages
        </p>
      </div>

      <div class="flex-1 flex justify-between sm:justify-end">
        <div>
          <%= if assigns.page_number > 1 do %>
            <%= live_redirect to: assigns.previous_link, class: "relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50" do %>
              Previous
            <% end %>
          <% end %>
        </div>

        <%= if assigns.page_number !== assigns.total_pages do %>
          <%= live_redirect to: assigns.next_link, class: "ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50" do %>
            Next
          <% end %>
        <% end %>
      </div>
    </nav>
    """
  end
end
