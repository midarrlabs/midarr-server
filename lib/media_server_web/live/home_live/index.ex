defmodule MediaServerWeb.HomeLive.Index do
  use MediaServerWeb, :live_view

  alias MediaServer.Repo
  alias MediaServer.Accounts
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
        |> Repo.preload(:continues)
      )
    }
  end

  @impl true
  def handle_params(_params, _url, socket) do
    pid = self()

    Task.start(fn ->
      send(pid, {:series, Series.get_latest(6)})
    end)

    {
      :noreply,
      socket
      |> assign(:movies, MediaServer.MovieIndexer.get_latest(7))
      |> assign(:user_continues, socket.assigns.current_user.continues)
    }
  end

  @impl true
  def handle_info({:series, series}, socket) do
    {
      :noreply,
      socket
      |> assign(:series, series)
    }
  end
end
