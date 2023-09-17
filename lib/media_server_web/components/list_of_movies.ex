defmodule MediaServerWeb.Components.ListOfMovies do
  use MediaServerWeb, :live_component

  import Ecto.Query

  @impl true
  def preload(list_of_assigns) do
    ids = Enum.flat_map(list_of_assigns, fn assign -> assign.ids end)
    token = Enum.find(list_of_assigns, fn assign -> Map.get(assign, :token) end).token
    user_id = Enum.find(list_of_assigns, fn assign -> Map.get(assign, :user_id) end).user_id

    query =
      from continue in MediaServer.Continues,
        where:
          continue.media_type_id == ^MediaServer.MediaTypes.get_movie_id() and
            continue.user_id == ^user_id and continue.media_id in ^ids

    result = MediaServer.Repo.all(query)

    Enum.map(list_of_assigns, fn assign ->
      %{
        id: assign.id,
        items:
          Enum.map(assign.ids, fn id ->
            movie = MediaServer.MoviesIndex.all() |> MediaServer.MoviesIndex.find(id)

            %{
              id: movie["id"],
              title: movie["title"],
              runtime: movie["movieFile"]["mediaInfo"]["runTime"],
              link: ~p"/movies/#{movie["id"]}",
              img_src: ~p"/api/images?movie=#{movie["id"]}&type=poster&token=#{token}",
              continue:
                Enum.find_value(result, nil, fn continue ->
                  if continue.media_id == movie["id"],
                    do: %{
                      current_time: continue.current_time,
                      duration: continue.duration
                    }
                end)
            }
          end)
      }
    end)
  end
end
