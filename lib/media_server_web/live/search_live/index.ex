defmodule MediaServerWeb.SearchLive.Index do
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
      |> assign(page_title: "Search")
    }
  end

  @impl true
  def handle_params(%{"query" => query}, _url, socket) do
    pid = self()

    Task.start(fn ->
      send(pid, {:movies, Flop.validate_and_run(MediaServer.Movies, %{filters:  [%{field: :title, op: :ilike, value: query}]}, for: MediaServer.Movies)})
    end)

    Task.start(fn ->
      send(pid, {:series, Flop.validate_and_run(MediaServer.Series, %{filters: [%{field: :title, op: :ilike, value: query}]}, for: MediaServer.Series)})
    end)

    {
      :noreply,
      socket
    }
  end

  def handle_params(_params, _url, socket) do
    {
      :noreply,
      socket
    }
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    {
      :noreply,
      socket
      |> push_navigate(to: ~p"/search?query=#{query}")
    }
  end

  @impl true
  def handle_info({:movies, movies}, socket) do

    {:ok, {data, _meta}} = movies

    {
      :noreply,
      socket
      |> assign(:movies, data)
    }
  end

  def handle_info({:series, series}, socket) do

    {:ok, {data, _meta}} = series

    {
      :noreply,
      socket
      |> assign(:series, data)
    }
  end
end
