defmodule MediaServerWeb.Components.ListSeries do
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
            Enum.map(series, fn serie ->
              item =
                MediaServer.SeriesIndex.all() |> MediaServer.SeriesIndex.find(serie.external_id)

              %{
                id: serie.external_id,
                series: item,
                link: ~p"/series/#{serie.external_id}",
                img_src: ~p"/api/images?series=#{serie.external_id}&type=poster&token=#{token}",
              }
            end)
        }
      ]
    end
end
