defmodule MediaServerWeb.FavouritesLive.Index do
  use MediaServerWeb, :live_view

  alias MediaServer.Repo
  alias MediaServer.Accounts

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(
        :current_user,
        Accounts.get_user_by_session_token(session["user_token"])
        |> Repo.preload(:movie_favourites)
        |> Repo.preload(:serie_favourites)
      )
    }
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {
      :noreply,
      socket
      |> assign(page_title: "Favourites")
      |> assign(:movie_favourites, socket.assigns.current_user.movie_favourites)
      |> assign(:serie_favourites, socket.assigns.current_user.serie_favourites)
    }
  end
end
