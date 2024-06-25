defmodule MediaServerWeb.PeopleLive.Index do
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
      |> assign(:page_title, "People")
    }
  end

  @impl true
  def handle_params(%{"page" => page}, _url, socket) do
    {:ok, {people, meta}} = Flop.validate_and_run(MediaServer.People, %{page: page, page_size: 25}, for: MediaServer.People)

    {
      :noreply,
      socket
      |> assign(:people, people)
      |> assign(:meta, meta)
    }
  end

  def handle_params(_params, _url, socket) do
    {:ok, {people, meta}} = Flop.validate_and_run(MediaServer.People, %{page: 1, page_size: 25}, for: MediaServer.People)

    {
      :noreply,
      socket
      |> assign(:people, people)
      |> assign(:meta, meta)
    }
  end
end
