defmodule MediaServerWeb.HomeLive.Index do
  use MediaServerWeb, :live_view

  alias MediaServer.Repo
  alias MediaServer.Accounts
  alias MediaServerWeb.Repositories.Movies
  alias MediaServerWeb.Repositories.Series

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(page_title: "Home")
      |> assign(
        :current_user,
        Accounts.get_user_by_session_token(session["user_token"])
        |> Repo.preload(:movie_continues)
        |> Repo.preload(:episode_continues)
      )
    }
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {
      :noreply,
      socket
      |> assign(:latest_movies, Movies.get_latest(7))
      |> assign(:latest_series, Series.get_latest(6))
      |> assign(:movie_continues, socket.assigns.current_user.movie_continues |> Enum.take(4))
      |> assign(:episode_continues, socket.assigns.current_user.episode_continues |> Enum.take(4))
    }
  end
end
