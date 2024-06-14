defmodule MediaServerWeb.Components.ListPeople do
  use MediaServerWeb, :live_component

  @impl true
  def preload(list_of_assigns) do
    id = Enum.find(list_of_assigns, fn assign -> Map.get(assign, :id) end).id
    query = Enum.find(list_of_assigns, fn assign -> Map.get(assign, :query) end).query
    token = Enum.find(list_of_assigns, fn assign -> Map.get(assign, :token) end).token

    entries = MediaServer.Repo.all(query)

    [
      %{
        id: id,
        items:
          Enum.map(entries, fn entry ->
            %{
              id: entry.tmdb_id,
              title: entry.name,
              link: ~p"/people/#{entry.tmdb_id}",
              img_src: ~p"/api/images?url=#{entry.image}&type=proxy&token=#{token}"
            }
          end)
      }
    ]
  end
end
