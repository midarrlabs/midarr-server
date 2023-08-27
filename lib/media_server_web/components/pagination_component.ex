defmodule MediaServerWeb.Components.PaginationComponent do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <dl class="mt-12 flex border-t border-slate-200 pt-6 dark:border-slate-800">
      <%= if assigns.page_number > 1 do %>
        <div>
          <dt class="font-display text-sm font-medium text-slate-900 dark:text-white">Previous</dt>
          <dd class="mt-1">
            <%= live_redirect id: "pagination-previous", to: assigns.previous_link, class: "flex items-center gap-x-1 text-base font-semibold text-slate-500 hover:text-slate-600 dark:text-slate-400 dark:hover:text-slate-300 flex-row-reverse" do %>
              Page <%= @page_number - 1 %>
              <svg
                viewBox="0 0 16 16"
                aria-hidden="true"
                class="h-4 w-4 flex-none fill-current -scale-x-100"
              >
                <path d="m9.182 13.423-1.17-1.16 3.505-3.505H3V7.065h8.517l-3.506-3.5L9.181 2.4l5.512 5.511-5.511 5.512Z">
                </path>
              </svg>
            <% end %>
          </dd>
        </div>
      <% end %>

      <%= if assigns.page_number !== assigns.total_pages do %>
        <div class="ml-auto text-right">
          <dt class="font-display text-sm font-medium text-slate-900 dark:text-white">Next</dt>
          <dd class="mt-1">
            <%= live_redirect id: "pagination-next", to: assigns.next_link, class: "flex items-center gap-x-1 text-base font-semibold text-slate-500 hover:text-slate-600 dark:text-slate-400 dark:hover:text-slate-300" do %>
              Page <%= @page_number + 1 %>
              <svg viewBox="0 0 16 16" aria-hidden="true" class="h-4 w-4 flex-none fill-current">
                <path d="m9.182 13.423-1.17-1.16 3.505-3.505H3V7.065h8.517l-3.506-3.5L9.181 2.4l5.512 5.511-5.511 5.512Z">
                </path>
              </svg>
            <% end %>
          </dd>
        </div>
      <% end %>
    </dl>
    """
  end
end
