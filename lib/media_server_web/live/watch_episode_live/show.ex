defmodule MediaServerWeb.WatchEpisodeLive.Show do
  use MediaServerWeb, :live_view

  alias MediaServerWeb.Repositories.Episodes
  alias MediaServer.Continues

  @impl true
  def handle_params(%{"episode" => episode_id}, _url, socket) do
    episode = Episodes.get_episode(episode_id)

    {
      :noreply,
      socket
      |> assign(:page_title, "#{episode["series"]["title"]}: #{episode["title"]}")
      |> assign(:episode, episode)
    }
  end

  @impl true
  def handle_event(
        "episode_destroyed",
        %{
          "episode_id" => episode_id,
          "serie_id" => serie_id,
          "current_time" => current_time,
          "duration" => duration,
          "user_id" => user_id
        },
        socket
      ) do
    episode = Episodes.get_episode(episode_id)

    Continues.update_or_create_episode(%{
      episode_id: episode_id,
      serie_id: serie_id,
      title: episode["title"],
      image_url: Episodes.get_background(episode),
      current_time: current_time,
      duration: duration,
      user_id: user_id
    })

    {:noreply, socket}
  end
end
