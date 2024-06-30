defmodule MediaServerWeb.HomeLive.Index do
  use MediaServerWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    {:ok,
     socket
     |> assign(
       :current_user,
       MediaServer.Accounts.get_user_by_session_token(session["user_token"])
     )
     |> assign(page_title: "Home")
    }
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:ok, {movies, _meta}} = Flop.validate_and_run(MediaServer.Movies, %{order_by: [:title], page: 1, page_size: 10}, for: MediaServer.Movies)

    {
      :noreply,
      socket
      |> assign(data: movies)
    }
  end
end
