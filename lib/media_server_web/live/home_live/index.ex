defmodule MediaServerWeb.HomeLive.Index do
  use MediaServerWeb, :live_view

  alias MediaServerWeb.Repositories.Movies
  alias MediaServerWeb.Repositories.Series

  @impl true
  def handle_params(_params, _url, socket) do
    latest_movies = Movies.get_latest(7)

    {:ok, latest_movie} = latest_movies |> Enum.fetch(0)

    {
      :noreply,
      socket
      |> assign(page_title: "Home")
      |> assign(:latest_movie, latest_movie)
      |> assign(:latest_movies, latest_movies |> Enum.drop(1))
      |> assign(:latest_series, Series.get_latest(6))
    }
  end
end
