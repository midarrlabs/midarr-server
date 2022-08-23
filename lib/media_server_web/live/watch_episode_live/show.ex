defmodule MediaServerWeb.WatchEpisodeLive.Show do
  use MediaServerWeb, :live_view

  alias MediaServer.Repo
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
      |> assign(
        :current_user,
        Accounts.get_user_by_session_token(session["user_token"])
        |> Repo.preload(:episode_continues)
      )
    }
  end

  @impl true
  def handle_params(%{"id" => id, "action" => "watch"}, _url, socket) do
    episode = Episodes.get_episode(id)

    {
      :noreply,
      socket
      |> assign(:page_title, "#{episode["series"]["title"]}: #{episode["title"]}")
      |> assign(:episode, episode)
      |> assign(:media_stream, Routes.stream_episode_path(socket, :show, episode["id"], token: Phoenix.Token.sign(MediaServerWeb.Endpoint, "user auth", socket.assigns.current_user.id)))
    }
  end

  def handle_params(%{"id" => id, "action" => "continue"}, _url, socket) do
    episode = Episodes.get_episode(id)

    {
      :noreply,
      socket
      |> assign(:page_title, "#{episode["series"]["title"]}: #{episode["title"]}")
      |> assign(:episode, episode)
      |> assign(:media_stream, Routes.stream_episode_path(socket, :show, episode["id"], token: Phoenix.Token.sign(MediaServerWeb.Endpoint, "user auth", socket.assigns.current_user.id)))
      |> assign(
        :continue,
        socket.assigns.current_user.episode_continues
        |> Enum.filter(fn item -> item.episode_id == episode["id"] end)
        |> List.first()
      )
    }
  end

  @impl true
  def handle_event(
        "video_destroyed",
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

  def handle_event("video_played", _params, socket) do
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
