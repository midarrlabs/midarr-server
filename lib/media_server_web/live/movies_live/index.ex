defmodule MediaServerWeb.MoviesLive.Index do
  use MediaServerWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(
        :current_user,
        MediaServer.Accounts.get_user_by_session_token(session["user_token"])
      )
      |> assign(:page_title, "Movies")
    }
  end

  @impl true
  def handle_params(%{"query" => query}, _url, socket) do
    {:ok, {data, meta}} = Flop.validate_and_run(MediaServer.Movies, %{filters:  [%{field: :title, op: :ilike, value: query}]}, for: MediaServer.Movies)

    {
      :noreply,
      socket
      |> assign(:movies, data)
      |> assign(:meta, meta)
    }
  end

  def handle_params(%{"page" => page}, _url, socket) do
    {:ok, {movies, meta}} = Flop.validate_and_run(MediaServer.Movies, %{order_by: [:title], page: page, page_size: 25}, for: MediaServer.Movies)

    {
      :noreply,
      socket
      |> assign(:movies, movies)
      |> assign(:meta, meta)
    }
  end

  def handle_params(_params, _url, socket) do
    {:ok, {movies, meta}} = Flop.validate_and_run(MediaServer.Movies, %{order_by: [:title], page: 1, page_size: 25}, for: MediaServer.Movies)

    {
      :noreply,
      socket
      |> assign(:movies, movies)
      |> assign(:meta, meta)
    }
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    {
      :noreply,
      socket
      |> push_redirect(to: ~p"/movies?query=#{query}")
    }
  end
end
