defmodule MediaServerWeb.SeriesLive.Show do
  use MediaServerWeb, :live_view

  alias MediaServer.Accounts

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(
        :current_user,
        Accounts.get_user_by_session_token(session["user_token"])
      )
    }
  end

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do

    series = MediaServer.SeriesIndex.get_serie(id)

    {
      :noreply,
      socket
      |> assign(:page_title, series["title"])
      |> assign(:serie, series)
    }
  end
end
