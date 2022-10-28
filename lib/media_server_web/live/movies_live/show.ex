defmodule MediaServerWeb.MoviesLive.Show do
  use MediaServerWeb, :live_view

  import Ecto.Query

  alias Phoenix.LiveView.JS
  alias MediaServer.Repo
  alias MediaServer.Accounts
  alias MediaServerWeb.Repositories.Movies
  alias MediaServer.Playlists

  alias MediaServer.Movies.Indexer

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(
        :current_user,
        Accounts.get_user_by_session_token(session["user_token"])
        |> Repo.preload(playlists: from(p in Playlists.Playlist, order_by: [desc: p.id]))
        |> Repo.preload(playlists: [:playlist_media])
      )
    }
  end

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    pid = self()

    Task.start(fn ->
      send(pid, {:cast, Movies.get_cast(id)})
    end)

    movie = Indexer.get_movie(id)

    {
      :noreply,
      socket
      |> assign(:id, id)
      |> assign(:page_title, movie["title"])
      |> assign(:movie, movie)
    }
  end

  @impl true
  def handle_info({:cast, cast}, socket) do
    {
      :noreply,
      socket
      |> assign(:cast, cast)
    }
  end

  @impl true
  def handle_event("save", %{"playlist" => playlist}, socket) do

    media = MediaServer.Media.find_or_create(%{
      media_id: socket.assigns.movie["id"],
      media_type_id: MediaServer.MediaTypes.get_id("movie")
    })

    MediaServer.Movies.Playlist.insert_or_delete(playlist, %{
      media_id: media.id,
    })

    {:noreply, socket}
  end
end
