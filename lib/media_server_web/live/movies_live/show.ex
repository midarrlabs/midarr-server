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

    continue_query =
      from mc in MediaServer.MovieContinues,
        where: mc.user_id == ^socket.assigns.current_user.id

    query =
      from m in MediaServer.Movies,
        where: m.external_id == ^id,
        preload: [continue: ^continue_query]

    result = MediaServer.Repo.one(query)

    {
      :noreply,
      socket
      |> assign(:id, id)
      |> assign(:page_title, movie["title"])
      |> assign(:movie, movie)
      |> assign(:similar, similar)
      |> assign(:continue, result.continue)
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
