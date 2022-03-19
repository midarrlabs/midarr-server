defmodule MediaServerWeb.HomeLive.Index do
  use MediaServerWeb, :live_view

  alias MediaServer.Accounts
  alias MediaServerWeb.Repositories.Movies
  alias MediaServerWeb.Repositories.Series

  @impl true
  def mount(_params, session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {
      :noreply,
      socket
      |> assign(page_title: "Home")
    }
  end
end
