defmodule MediaServerWeb.Components.ListOfMovies do
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
            movie =
              MediaServer.MoviesIndex.all() |> MediaServer.MoviesIndex.find(entry.external_id)

            %{
              id: entry.external_id,
              movie: movie,
              link: ~p"/movies/#{entry.external_id}",
              img_src: ~p"/api/images?movie=#{entry.external_id}&type=background&size=w780&token=#{token}",
            }
          end)
      }
    ]
  end
end
