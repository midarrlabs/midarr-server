defmodule MediaServerWeb.FavouritesLive.Index do
  use MediaServerWeb, :live_view

  alias MediaServer.Accounts

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
