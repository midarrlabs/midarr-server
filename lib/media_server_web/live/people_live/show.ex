defmodule MediaServerWeb.PeopleLive.Show do
  use MediaServerWeb, :live_view

  import Ecto.Query

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

    query =
      from person in MediaServer.People,
        where: person.id == ^id

    item = MediaServer.Repo.all(query) |> List.first()

    pid = self()

    Task.start(fn ->
      send(pid, {:person, OapiTmdb.Operations.person_details(item.tmdb_id)})
    end)

    {
      :noreply,
      socket
      |> assign(:page_title, item.name)
      |> assign(:item, item)
    }
  end

  @impl true
  def handle_info({:person, person}, socket) do
    {
      :noreply,
      socket
      |> assign(:person, person)
    }
  end
end
