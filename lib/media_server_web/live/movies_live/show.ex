defmodule MediaServerWeb.MoviesLive.Show do
  use MediaServerWeb, :live_view

  alias MediaServer.Accounts
  alias MediaServerWeb.Repositories.Movies
  alias MediaServer.Favourites

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(
        :current_user,
        Accounts.get_user_only_by_session_token(session["user_token"])
      )
    }
  end

  @impl true
  def handle_params(%{"movie" => id}, _url, socket) do
    movie = Movies.get_movie(id)

    {:noreply,
     socket
     |> assign(:page_title, movie["title"])
     |> assign(:movie, movie)}
  end

  @impl true
  def handle_event(
        "favourite",
        %{
          "movie_id" => movie_id
        },
        socket
      ) do
    movie = Movies.get_movie(movie_id)

    Favourites.create_movie(%{
      movie_id: movie_id,
      title: movie["title"],
      image_url: Movies.get_background(movie),
      user_id: socket.assigns.current_user.id
    })

    {:noreply, socket}
  end
end
