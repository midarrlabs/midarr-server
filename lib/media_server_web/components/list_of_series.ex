defmodule MediaServerWeb.Components.ListOfSeries do
  use MediaServerWeb, :live_component

  @impl true
  def preload(list_of_assigns) do
    ids = Enum.flat_map(list_of_assigns, fn assign -> assign.ids end)
    token = Enum.find(list_of_assigns, fn assign -> Map.get(assign, :token) end).token
    user_id = Enum.find(list_of_assigns, fn assign -> Map.get(assign, :user_id) end).user_id

    Enum.map(list_of_assigns, fn assign ->
      %{
        id: assign.id,
        items:
          Enum.map(assign.ids, fn id ->
            series = MediaServer.SeriesIndex.all() |> MediaServer.SeriesIndex.find(id)

            %{
              id: series["id"],
              title: series["title"],
              link: ~p"/series/#{series["id"]}",
              img_src: ~p"/api/images?series=#{series["id"]}&type=poster&token=#{token}"
            }
          end)
      }
    end)
  end
end
