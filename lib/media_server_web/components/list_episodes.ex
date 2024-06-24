defmodule MediaServerWeb.Components.ListEpisodes do
  use MediaServerWeb, :live_component

  @impl true
  def preload(list_of_assigns) do
    episodes = Enum.find(list_of_assigns, fn assign -> Map.get(assign, :episodes) end).episodes
    token = Enum.find(list_of_assigns, fn assign -> Map.get(assign, :token) end).token

    [
      %{
        id: "episodes",
        items:
          Enum.map(episodes, fn episode ->
            %{
              title: episode.title,
              overview: episode.overview,
              img_src: "/api/images?url=#{episode.screenshot}&type=proxy&token=#{token}"
            }
          end)
      }
    ]
  end
end
