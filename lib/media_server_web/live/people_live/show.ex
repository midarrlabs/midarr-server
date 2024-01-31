defmodule MediaServerWeb.PeopleLive.Show do
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
    }
  end

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    pid = self()

    Task.start(fn ->
      send(pid, {:person, OapiTmdb.Operations.person_details(id)})
    end)

    {
      :noreply,
      socket
      |> assign(:id, id)
    }
  end

  @impl true
  def handle_info({:person, person}, socket) do
    {
      :noreply,
      socket
      |> assign(:page_title, person["name"])
      |> assign(:person, person)
    }
  end
end