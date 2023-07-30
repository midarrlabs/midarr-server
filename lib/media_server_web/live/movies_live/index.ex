defmodule MediaServerWeb.MoviesLive.Index do
  use MediaServerWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(:current_user, MediaServer.Accounts.get_user_by_session_token(session["user_token"]))
      |> assign(:page_title, "Movies")
    }
  end

  @impl true
  def handle_params(%{"genre" => genre, "page" => page}, _url, socket) do

    capitalized_genre = String.capitalize(genre)

    movies = Scrivener.paginate(MediaServer.MoviesIndex.all() |> MediaServer.MoviesIndex.genre(capitalized_genre), %{
      "page" => page,
      "page_size" => "50"
    })

    {
      :noreply,
      socket
      |> assign(:page_title, "Movies - #{ capitalized_genre }")
      |> assign(:movies, movies)
      |> assign(:previous_link, ~p"/movies?genre=#{ genre }&page=#{ MediaServerWeb.Helpers.get_pagination_previous_link(movies.page_number) }")
      |> assign(:next_link, ~p"/movies?genre=#{ genre }&page=#{ MediaServerWeb.Helpers.get_pagination_next_link(movies.page_number) }")
      |> assign(:genre, genre)
    }
  end

  def handle_params(%{"genre" => genre}, _url, socket) do

    capitalized_genre = String.capitalize(genre)

    movies = Scrivener.paginate(MediaServer.MoviesIndex.all() |> MediaServer.MoviesIndex.genre(capitalized_genre), %{
      "page" => "1",
      "page_size" => "50"
    })

    {
      :noreply,
      socket
      |> assign(:page_title, "Movies - #{ capitalized_genre }")
      |> assign(:movies, movies)
      |> assign(:previous_link, ~p"/movies?genre=#{ genre }&page=#{ MediaServerWeb.Helpers.get_pagination_previous_link(movies.page_number) }")
      |> assign(:next_link, ~p"/movies?genre=#{ genre }&page=#{ MediaServerWeb.Helpers.get_pagination_next_link(movies.page_number) }")
      |> assign(:genre, genre)
    }
  end

  def handle_params(%{"sort_by" => "latest", "page" => page}, _url, socket) do

    movies = Scrivener.paginate(MediaServer.MoviesIndex.all() |> MediaServer.MoviesIndex.latest(), %{
      "page" => page,
      "page_size" => "50"
    })

    {
      :noreply,
      socket
      |> assign(:page_title, "Movies - Latest")
      |> assign(:movies, movies)
      |> assign(:previous_link, ~p"/movies?sort_by=latest&page=#{ MediaServerWeb.Helpers.get_pagination_previous_link(movies.page_number) }")
      |> assign(:next_link, ~p"/movies?sort_by=latest&page=#{ MediaServerWeb.Helpers.get_pagination_next_link(movies.page_number) }")
      |> assign(:genre, "latest")
    }
  end

  def handle_params(%{"sort_by" => "latest"}, _url, socket) do

    movies = Scrivener.paginate(MediaServer.MoviesIndex.all() |> MediaServer.MoviesIndex.latest(), %{
      "page" => "1",
      "page_size" => "50"
    })

    {
      :noreply,
      socket
      |> assign(:page_title, "Movies - Latest")
      |> assign(:movies, movies)
      |> assign(:previous_link, ~p"/movies?sort_by=latest&page=#{ MediaServerWeb.Helpers.get_pagination_previous_link(movies.page_number) }")
      |> assign(:next_link, ~p"/movies?sort_by=latest&page=#{ MediaServerWeb.Helpers.get_pagination_next_link(movies.page_number) }")
      |> assign(:genre, "latest")
    }
  end

  def handle_params(%{"page" => page}, _url, socket) do

    movies = Scrivener.paginate(MediaServer.MoviesIndex.all(), %{
      "page" => page,
      "page_size" => "50"
    })

    {
      :noreply,
      socket
      |> assign(:movies, movies)
      |> assign(:previous_link, ~p"/movies?page=#{ MediaServerWeb.Helpers.get_pagination_previous_link(movies.page_number) }")
      |> assign(:next_link, ~p"/movies?page=#{ MediaServerWeb.Helpers.get_pagination_next_link(movies.page_number) }")
      |> assign(:genre, "A-Z")
    }
  end

  def handle_params(_params, _url, socket) do

    movies = Scrivener.paginate(MediaServer.MoviesIndex.all(), %{
      "page" => "1",
      "page_size" => "50"
    })

    {
      :noreply,
      socket
      |> assign(:movies, movies)
      |> assign(:previous_link, ~p"/movies?page=#{ MediaServerWeb.Helpers.get_pagination_previous_link(movies.page_number) }")
      |> assign(:next_link, ~p"/movies?page=#{ MediaServerWeb.Helpers.get_pagination_next_link(movies.page_number) }")
      |> assign(:genre, "A-Z")
    }
  end
end
