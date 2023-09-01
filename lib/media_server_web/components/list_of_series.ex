defmodule MediaServerWeb.Components.ListOfSeries do
  use MediaServerWeb, :live_component

  @impl true
  def preload([%{id: id, items: items, token: token}]) do

    [%{id: id, items: Enum.map(items, fn item ->
      %{
        id: item.id,
        title: item.title,
        link: ~p"/series/#{item.id}",
        img_src: ~p"/api/images?series=#{item.id}&type=poster&size=w780&token=#{token}"
      }
    end) }]
  end
end
