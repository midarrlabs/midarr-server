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
    query =
      from movies in MediaServer.Movies,
        where: movies.id == ^id

    movie = MediaServer.Repo.all(query) |> List.first()

    {
      :noreply,
      socket
      |> assign(:id, id)
      |> assign(:page_title, movie.title)
      |> assign(:movie, movie)
    }
  end
end
