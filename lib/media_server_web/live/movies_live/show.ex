defmodule MediaServerWeb.MoviesLive.Show do
  use MediaServerWeb, :live_view

  alias MediaServer.Repo
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
        Accounts.get_user_by_session_token(session["user_token"])
        |> Repo.preload(:movie_favourites)
      )
    }
  end

  @impl true
  def handle_params(%{"movie" => movie_id}, _url, socket) do
    movie = Movies.get_movie(movie_id)

    {:noreply,
     socket
     |> assign(:page_title, movie["title"])
     |> assign(:movie, movie)
     |> assign(:cast, Movies.get_cast(movie_id))
     |> assign(
       :favourite,
       socket.assigns.current_user.movie_favourites
       |> Enum.find(fn favourite -> favourite.movie_id === String.to_integer(movie_id) end)
     )}
  end

  @impl true
  def handle_event(
        "favourite",
        _params,
        socket
      ) do
    Favourites.create_movie(%{
      movie_id: socket.assigns.movie["id"],
      title: socket.assigns.movie["title"],
      image_url: Movies.get_poster(socket.assigns.movie),
      user_id: socket.assigns.current_user.id
    })

    {
      :noreply,
      socket
      |> push_redirect(to: Routes.movies_show_path(socket, :show, socket.assigns.movie["id"]))
    }
  end

  @impl true
  def handle_event(
        "unfavourite",
        _params,
        socket
      ) do
    Favourites.delete_movie(Favourites.get_movie!(socket.assigns.favourite.id))

    {
      :noreply,
      socket
      |> push_redirect(to: Routes.movies_show_path(socket, :show, socket.assigns.movie["id"]))
    }
  end
end
