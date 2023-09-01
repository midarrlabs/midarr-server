defmodule MediaServerWeb.Components.ListOfMovies do
  use MediaServerWeb, :live_component

  import Ecto.Query

  @impl true
  def preload([%{id: id, ids: ids, items: items, token: token, user_id: user_id}]) do

    query =
      from continue in MediaServer.Continues,
           where: continue.user_id == ^user_id and continue.media_id in ^ids,
           order_by: [desc: continue.updated_at],
           limit: 10

    result = MediaServer.Repo.all(query)

    [%{
      id: id,
      items: Enum.map(items, fn item ->
        %{
          id: item.id,
          title: item.title,
          link: ~p"/movies/#{item.id}",
          img_src: ~p"/api/images?movie=#{item.id}&type=poster&size=w780&token=#{token}",
          continue: Enum.find_value(result, nil, fn continue -> if continue.media_id == item.id, do: %{
            current_time: continue.current_time,
            duration: continue.duration
          } end)
        }
      end)
    }]
  end
end
