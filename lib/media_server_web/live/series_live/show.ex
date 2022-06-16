defmodule MediaServerWeb.SeriesLive.Show do
  use MediaServerWeb, :live_view

  alias MediaServer.Repo
  alias MediaServer.Accounts
  alias MediaServerWeb.Repositories.Series
  alias MediaServer.Favourites

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(
        :current_user,
        Accounts.get_user_by_session_token(session["user_token"])
        |> Repo.preload(:serie_favourites)
      )
    }
  end

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    serie = Series.get_serie(id)

    {
      :noreply,
      socket
      |> assign(:page_title, serie["title"])
      |> assign(:serie, serie)
      |> assign(
        :favourite,
        socket.assigns.current_user.serie_favourites
        |> Enum.find(fn favourite -> favourite.serie_id === String.to_integer(id) end)
      )
    }
  end

  @impl true
  def handle_event(
        "favourite",
        _params,
        socket
      ) do
    Favourites.create_serie(%{
      serie_id: socket.assigns.serie["id"],
      title: socket.assigns.serie["title"],
      image_url: Series.get_poster(socket.assigns.serie),
      user_id: socket.assigns.current_user.id
    })

    {
      :noreply,
      socket
      |> push_redirect(to: Routes.series_show_path(socket, :show, socket.assigns.serie["id"]))
    }
  end

  def handle_event(
        "unfavourite",
        _params,
        socket
      ) do
    Favourites.delete_serie(Favourites.get_serie!(socket.assigns.favourite.id))

    {
      :noreply,
      socket
      |> push_redirect(to: Routes.series_show_path(socket, :show, socket.assigns.serie["id"]))
    }
  end
end
