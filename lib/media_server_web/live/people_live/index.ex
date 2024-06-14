defmodule MediaServerWeb.PeopleLive.Index do
  use MediaServerWeb, :live_view

  import Ecto.Query

  @impl true
  def mount(_params, session, socket) do
    query =
      from m in MediaServer.People,
        order_by: [desc: m.inserted_at],
        limit: 25

    {
      :ok,
      socket
      |> assign(
        :current_user,
        MediaServer.Accounts.get_user_by_session_token(session["user_token"])
      )
      |> assign(:page_title, "People")
      |> assign(query: query)
    }
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {
      :noreply,
      socket
    }
  end
end
