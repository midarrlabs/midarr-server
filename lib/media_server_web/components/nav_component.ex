defmodule MediaServerWeb.Components.NavComponent do
  use MediaServerWeb, :live_component

  alias Phoenix.LiveView.JS

  @impl true
  def handle_event("search", %{"search" => %{"query" => query}}, socket) do
    {
      :noreply,
      socket
      |> push_redirect(to: Routes.search_index_path(socket, :index, query: query))
    }
  end
end
