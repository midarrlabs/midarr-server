defmodule MediaServerWeb.Components.PosterComponent do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <div class="bg-blend-overlay relative aspect-auto w-40 md:w-48 h-64 md:h-72 flex-none overflow-hidden rounded-sm hover:opacity-75">
      <%= live_redirect to: assigns.link do %>
        <%= if assigns.img_src !== "" do %>
          <img
            alt={assigns.title}
            src={MediaServerWeb.Helpers.reduce_size_for_poster_url(assigns.img_src)}
            loading="lazy"
          />
        <% else %>
          <div class="dark:bg-zinc-800/90 h-full w-full"></div>
        <% end %>
      <% end %>
    </div>
    """
  end
end
