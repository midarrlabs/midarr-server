defmodule MediaServerWeb.Components.ListOfEpisodes do
  use MediaServerWeb, :live_component

  import Ecto.Query

  @impl true
  def preload(list_of_assigns) do
    series_id = Enum.find(list_of_assigns, fn assign -> Map.get(assign, :series_id) end).series_id
    season = Enum.find(list_of_assigns, fn assign -> Map.get(assign, :season) end).season

    token = Enum.find(list_of_assigns, fn assign -> Map.get(assign, :token) end).token
    user_id = Enum.find(list_of_assigns, fn assign -> Map.get(assign, :user_id) end).user_id

    episodes = MediaServerWeb.Repositories.Episodes.get_all(series_id, season)

    episode_ids = Enum.flat_map(episodes, fn episode -> [episode["id"]] end)

    query =
      from continue in MediaServer.Continues,
        where:
          continue.media_type_id == ^MediaServer.MediaTypes.get_episode_id() and
            continue.user_id == ^user_id and continue.media_id in ^episode_ids

    result = MediaServer.Repo.all(query)

    Enum.map(list_of_assigns, fn assign ->
      %{
        id: assign.id,
        items:
          Enum.map(episodes, fn episode ->
            %{
              id: episode["id"],
              title: episode["title"],
              overview: episode["overview"],
              has_file: episode["hasFile"],
              img_src: ~p"/api/images?episode=#{episode["id"]}&type=screenshot&token=#{token}",
              continue:
                Enum.find_value(result, nil, fn continue ->
                  if continue.media_id == episode["id"],
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
