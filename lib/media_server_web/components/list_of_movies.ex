defmodule MediaServerWeb.Components.ListOfMovies do
  use MediaServerWeb, :live_component

  @impl true
  def preload(list_of_assigns = [%{id: id, items: items, token: token}]) do

    [%{id: id, items: Enum.map(items, fn item ->
      %{
        id: item.id,
        title: item.title,
        link: ~p"/movies/#{item.id}",
        img_src: ~p"/api/images?movie=#{item.id}&type=poster&size=w780&token=#{token}"
      }
    end) }]
  end
end
