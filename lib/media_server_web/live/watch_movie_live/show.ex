defmodule MediaServerWeb.WatchMovieLive.Show do
  use MediaServerWeb, :live_view

  alias MediaServer.Accounts
  alias MediaServerWeb.Repositories.Movies
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
  def handle_params(%{"movie" => movie_id}, _url, socket) do
    movie = Movies.get_movie(movie_id)

    {
      :noreply,
      socket
      |> assign(:page_title, "#{movie["title"]}")
      |> assign(:movie, movie)
    }
  end

  @impl true
  def handle_event(
        "movie_destroyed",
        %{
          "current_time" => current_time,
          "duration" => duration
        },
        socket
      ) do
    Continues.update_or_create_movie(%{
      movie_id: socket.assigns.movie["id"],
      title: socket.assigns.movie["title"],
      image_url: Movies.get_background(socket.assigns.movie),
      current_time: current_time,
      duration: duration,
      user_id: socket.assigns.current_user.id
    })

    {:noreply, socket}
  end

  def handle_event("movie_played", _params, socket) do
    action = Components.list_actions() |> List.first()

    Actions.create_movie(%{
      movie_id: socket.assigns.movie["id"],
      title: socket.assigns.movie["title"],
      user_id: socket.assigns.current_user.id,
      action_id: action.id
    })

    {:noreply, socket}
  end
end
