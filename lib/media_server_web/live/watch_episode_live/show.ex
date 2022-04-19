defmodule MediaServerWeb.WatchEpisodeLive.Show do
  use MediaServerWeb, :live_view

  alias MediaServer.Accounts
  alias MediaServerWeb.Repositories.Episodes
  alias MediaServer.Continues
  alias MediaServer.Components
  alias MediaServer.Actions

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(:current_user, Accounts.get_user_by_session_token(session["user_token"]))
    }
  end

  @impl true
  def handle_params(%{"episode" => episode_id}, _url, socket) do
    episode = Episodes.get_episode(episode_id)

    create_action(episode, socket)

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

  defp create_action(episode, socket) do
    action = Components.list_actions() |> List.first()

    Actions.create_episode(%{
      episode_id: episode["id"],
      serie_id: episode["seriesId"],
      title: episode["title"],
      user_id: socket.assigns.current_user.id,
      action_id: action.id
    })
  end
end
