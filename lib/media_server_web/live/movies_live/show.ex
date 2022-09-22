defmodule MediaServerWeb.MoviesLive.Show do
  use MediaServerWeb, :live_view

  import Ecto.Query

  alias Phoenix.LiveView.JS
  alias MediaServer.Repo
  alias MediaServer.Accounts
  alias MediaServerWeb.Repositories.Movies
  alias MediaServer.Favourites
  alias MediaServer.Playlists

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(
        :current_user,
        Accounts.get_user_by_session_token(session["user_token"])
        |> Repo.preload(:movie_favourites)
        |> Repo.preload(playlists: from(p in Playlists.Playlist, order_by: [desc: p.id]))
        |> Repo.preload(playlists: [:movies])
      )
    }
  end

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    pid = self()

    Task.start(fn ->
      send(pid, {:movie, Movies.get_movie(id)})
    end)

    Task.start(fn ->
      send(pid, {:cast, Movies.get_cast(id)})
    end)

    {:noreply,
     socket
     |> assign(:id, id)
     |> assign(
       :favourite,
       socket.assigns.current_user.movie_favourites
       |> Enum.find(fn favourite -> favourite.movie_id === String.to_integer(id) end)
     )}
  end

  @impl true
  def handle_info({:movie, movie}, socket) do
    {
      :noreply,
      socket
      |> assign(:page_title, movie["title"])
      |> assign(:movie, movie)
    }
  end

  def handle_info({:cast, cast}, socket) do
    {
      :noreply,
      socket
      |> assign(:cast, cast)
    }
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

  def handle_event("save", %{"playlist" => playlist}, socket) do
    Playlists.insert_or_update_all(playlist, %{
      movie_id: socket.assigns.movie["id"],
      title: socket.assigns.movie["title"],
      image_url: Movies.get_poster(socket.assigns.movie)
    })

    {:noreply, socket}
  end
end
