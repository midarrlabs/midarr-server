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
  def handle_params(%{"id" => id}, _url, socket) do
    episode = Episodes.get_episode(id)

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
          "current_time" => current_time,
          "duration" => duration
        },
        socket
      ) do
    Continues.update_or_create_episode(%{
      episode_id: socket.assigns.episode["id"],
      serie_id: socket.assigns.episode["seriesId"],
      title: socket.assigns.episode["title"],
      image_url: Episodes.get_background(socket.assigns.episode),
      current_time: current_time,
      duration: duration,
      user_id: socket.assigns.current_user.id
    })

    {:noreply, socket}
  end

  def handle_event("episode_played", _params, socket) do
    action = Components.list_actions() |> List.first()

    Actions.create_episode(%{
      episode_id: socket.assigns.episode["id"],
      serie_id: socket.assigns.episode["seriesId"],
      title: socket.assigns.episode["title"],
      user_id: socket.assigns.current_user.id,
      action_id: action.id
    })

    {:noreply, socket}
  end
end
