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
        Accounts.get_user_by_session_token_with_favourites(session["user_token"])
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
     |> assign(
       :favourite,
       socket.assigns.current_user.movie_favourites
       |> Enum.find(fn favourite -> favourite.movie_id === String.to_integer(movie_id) end)
     )}
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
      image_url: Movies.get_poster(movie),
      user_id: socket.assigns.current_user.id
    })

    {
      :noreply,
      socket
      |> push_redirect(to: Routes.movies_show_path(socket, :show, movie_id))
    }
  end

  @impl true
  def handle_event(
        "unfavourite",
        %{
          "id" => id,
          "movie_id" => movie_id
        },
        socket
      ) do
    Favourites.delete_movie(Favourites.get_movie!(id))

    {
      :noreply,
      socket
      |> push_redirect(to: Routes.movies_show_path(socket, :show, movie_id))
    }
  end
end
