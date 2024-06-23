defmodule MediaServerWeb.Components.ListOfMovies do
  use MediaServerWeb, :live_component

  @impl true
  def preload(list_of_assigns) do
    id = Enum.find(list_of_assigns, fn assign -> Map.get(assign, :id) end).id
    movies = Enum.find(list_of_assigns, fn assign -> Map.get(assign, :movies) end).movies
    token = Enum.find(list_of_assigns, fn assign -> Map.get(assign, :token) end).token

    [
      %{
        id: id,
        items:
          Enum.map(movies, fn movie ->
            item =
              MediaServer.MoviesIndex.all() |> MediaServer.MoviesIndex.find(movie.external_id)

            %{
              id: movie.external_id,
              movie: item,
              link: ~p"/movies/#{movie.external_id}",
              img_src: ~p"/api/images?movie=#{movie.external_id}&type=poster&token=#{token}",
            }
          end)
      }
    ]
  end
end
