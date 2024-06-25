defmodule MediaServerWeb.Components.ListSeries do
    use MediaServerWeb, :live_component

    @impl true
    def preload(list_of_assigns) do
      series = Enum.find(list_of_assigns, fn assign -> Map.get(assign, :series) end).series
      token = Enum.find(list_of_assigns, fn assign -> Map.get(assign, :token) end).token

      [
        %{
          id: "series",
          items:
            Enum.map(series, fn serie ->
              %{
                link: ~p"/series/#{serie.id}",
                img_src: "/api/images?url=#{serie.poster}&type=proxy&token=#{token}"
              }
            end)
        }
      ]
    end
end
