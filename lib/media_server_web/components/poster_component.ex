defmodule MediaServerWeb.Components.PosterComponent do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
      <div class="bg-blend-overlay relative aspect-[4/6] w-34 flex-none overflow-hidden rounded-md bg-zinc-100 dark:bg-zinc-800">
        <%= live_redirect to: assigns.link do %>
            <img
              alt=""
              src={MediaServerWeb.Helpers.reduce_size_for_poster_url(assigns.img_src)}
              loading="lazy"
            />
        <% end %>
      </div>
    """
  end
end
