defmodule MediaServerWeb.SeriesLive.Show do
  use MediaServerWeb, :live_view

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
        Accounts.get_user_by_session_token_with_favourites(session["user_token"])
      )
    }
  end

  @impl true
  def handle_params(%{"serie" => serie_id}, _url, socket) do
    serie = Series.get_serie(serie_id)

    {
      :noreply,
      socket
      |> assign(:page_title, serie["title"])
      |> assign(:serie, serie)
      |> assign(
        :favourite,
        socket.assigns.current_user.serie_favourites
        |> Enum.find(fn favourite -> favourite.serie_id === String.to_integer(serie_id) end)
      )
    }
  end

  @impl true
  def handle_event(
        "favourite",
        %{
          "serie_id" => serie_id
        },
        socket
      ) do
    serie = Series.get_serie(serie_id)

    Favourites.create_serie(%{
      serie_id: serie_id,
      title: serie["title"],
      image_url: Series.get_poster(serie),
      user_id: socket.assigns.current_user.id
    })

    {
      :noreply,
      socket
      |> push_redirect(to: Routes.series_show_path(socket, :show, serie_id))
    }
  end

  @impl true
  def handle_event(
        "unfavourite",
        %{
          "id" => id,
          "serie_id" => serie_id
        },
        socket
      ) do
    Favourites.delete_serie(Favourites.get_serie!(id))

    {
      :noreply,
      socket
      |> push_redirect(to: Routes.series_show_path(socket, :show, serie_id))
    }
  end
end
