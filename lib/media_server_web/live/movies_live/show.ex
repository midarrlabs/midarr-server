defmodule MediaServerWeb.MoviesLive.Show do
  use MediaServerWeb, :live_view

  import Ecto.Query

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(
        :current_user,
        MediaServer.Accounts.get_user_by_session_token(session["user_token"])
      )
    }
  end

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    pid = self()

    Task.start(fn ->
      send(pid, {:cast, MediaServerWeb.Repositories.Movies.get_cast(id)})
    end)

    movie = MediaServer.MoviesIndex.find(MediaServer.MoviesIndex.all(), id)
    similar = MediaServer.MoviesIndex.related(MediaServer.MoviesIndex.all(), movie["id"])

    query =
      from continue in MediaServer.Continues,
           where: continue.user_id == ^socket.assigns.current_user.id and continue.media_id == ^id

    result = MediaServer.Repo.one(query)

    {
      :noreply,
      socket
      |> assign(:id, id)
      |> assign(:page_title, movie["title"])
      |> assign(:movie, movie)
      |> assign(:similar, similar)
      |> assign(:continue, result)
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
end
