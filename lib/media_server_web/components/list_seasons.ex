defmodule MediaServerWeb.Components.ListSeasons do
  use MediaServerWeb, :live_component

  @impl true
  def preload(list_of_assigns) do
    id = Enum.find(list_of_assigns, fn assign -> Map.get(assign, :id) end).id
    series = Enum.find(list_of_assigns, fn assign -> Map.get(assign, :series) end).series
    token = Enum.find(list_of_assigns, fn assign -> Map.get(assign, :token) end).token

    [
      %{
        id: id,
        items:
          Enum.map(series["seasons"], fn season ->
            %{
              id: series["id"],
              title: "Season #{season["seasonNumber"]}",
              link: "/series/#{series["id"]}?season=#{season["seasonNumber"]}",
              img_src: "/api/images?url=#{MediaServer.Helpers.get_poster(season)}&type=proxy&token=#{token}"
            }
          end)
      }
    ]
  end
end
