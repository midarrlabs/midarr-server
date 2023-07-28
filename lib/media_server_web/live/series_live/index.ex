defmodule MediaServerWeb.SeriesLive.Index do
  use MediaServerWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(:current_user, MediaServer.Accounts.get_user_by_session_token(session["user_token"]))
      |> assign(:page_title, "Series")
    }
  end

  @impl true
  def handle_params(%{"genre" => genre, "page" => page}, _url, socket) do

    capitalized_genre = String.capitalize(genre)

    series = Scrivener.paginate(MediaServer.SeriesIndex.all() |> MediaServer.SeriesIndex.genre(capitalized_genre), %{
      "page" => page,
      "page_size" => "50"
    })

    {
      :noreply,
      socket
      |> assign(:page_title, "Series - #{ capitalized_genre }")
      |> assign(:series, series)
      |> assign(:previous_link, ~p"/series?genre=#{ genre }&page=#{ MediaServerWeb.Helpers.get_pagination_previous_link(series.page_number) }")
      |> assign(:next_link, ~p"/series?genre=#{ genre }&page=#{ MediaServerWeb.Helpers.get_pagination_next_link(series.page_number) }")
      |> assign(:genre, genre)
    }
  end

  def handle_params(%{"genre" => genre}, _url, socket) do

    capitalized_genre = String.capitalize(genre)

    series = Scrivener.paginate(MediaServer.SeriesIndex.all() |> MediaServer.SeriesIndex.genre(capitalized_genre), %{
      "page" => "1",
      "page_size" => "50"
    })

    {
      :noreply,
      socket
      |> assign(:page_title, "Series - #{ capitalized_genre }")
      |> assign(:series, series)
      |> assign(:previous_link, ~p"/series?genre=#{ genre }&page=#{ MediaServerWeb.Helpers.get_pagination_previous_link(series.page_number) }")
      |> assign(:next_link, ~p"/series?genre=#{ genre }&page=#{ MediaServerWeb.Helpers.get_pagination_next_link(series.page_number) }")
      |> assign(:genre, genre)
    }
  end

  def handle_params(%{"sort_by" => "latest", "page" => page}, _url, socket) do

    series = Scrivener.paginate(MediaServer.SeriesIndex.all() |> MediaServer.SeriesIndex.latest(), %{
      "page" => page,
      "page_size" => "50"
    })

    {
      :noreply,
      socket
      |> assign(:page_title, "Series - Latest")
      |> assign(:series, series)
      |> assign(:previous_link, ~p"/series?sort_by=latest&page=#{ MediaServerWeb.Helpers.get_pagination_previous_link(series.page_number) }")
      |> assign(:next_link, ~p"/series?sort_by=latest&page=#{ MediaServerWeb.Helpers.get_pagination_next_link(series.page_number) }")
      |> assign(:genre, "latest")
    }
  end

  def handle_params(%{"sort_by" => "latest"}, _url, socket) do

    series = Scrivener.paginate(MediaServer.SeriesIndex.all() |> MediaServer.SeriesIndex.latest(), %{
      "page" => "1",
      "page_size" => "50"
    })

    {
      :noreply,
      socket
      |> assign(:page_title, "Series - Latest")
      |> assign(:series, series)
      |> assign(:previous_link, ~p"/series?sort_by=latest&page=#{ MediaServerWeb.Helpers.get_pagination_previous_link(series.page_number) }")
      |> assign(:next_link, ~p"/series?sort_by=latest&page=#{ MediaServerWeb.Helpers.get_pagination_next_link(series.page_number) }")
      |> assign(:genre, "latest")
    }
  end

  def handle_params(%{"page" => page}, _url, socket) do

    series = Scrivener.paginate(MediaServer.SeriesIndex.all(), %{
      "page" => page,
      "page_size" => "50"
    })

    {
      :noreply,
      socket
      |> assign(:series, series)
      |> assign(:previous_link, ~p"/series?page=#{ MediaServerWeb.Helpers.get_pagination_previous_link(series.page_number) }")
      |> assign(:next_link, ~p"/series?page=#{ MediaServerWeb.Helpers.get_pagination_next_link(series.page_number) }")
      |> assign(:genre, "A-Z")
    }
  end

  def handle_params(_params, _url, socket) do

    series = Scrivener.paginate(MediaServer.SeriesIndex.all(), %{
      "page" => "1",
      "page_size" => "50"
    })

    {
      :noreply,
      socket
      |> assign(:series, series)
      |> assign(:previous_link, ~p"/series?page=#{ MediaServerWeb.Helpers.get_pagination_previous_link(series.page_number) }")
      |> assign(:next_link, ~p"/series?page=#{ MediaServerWeb.Helpers.get_pagination_next_link(series.page_number) }")
      |> assign(:genre, "A-Z")
    }
  end
end
