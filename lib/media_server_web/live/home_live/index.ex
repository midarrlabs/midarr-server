defmodule MediaServerWeb.HomeLive.Index do
  use MediaServerWeb, :live_view

  alias MediaServer.Accounts
  alias MediaServerWeb.Repositories.Movies
  alias MediaServerWeb.Repositories.Series

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(:current_user, Accounts.get_user_by_session_token(session["user_token"]))
    }
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {
      :noreply,
      socket
      |> assign(page_title: "Home")
      |> assign(:latest_movies, Movies.get_latest(7))
      |> assign(:latest_series, Series.get_latest(6))
      |> assign(:movie_watch_statuses, socket.assigns.current_user.movie_watch_statuses |> Enum.take(4))
    }
  end
end
