defmodule MediaServerWeb.MoviesLive.Index do
  use MediaServerWeb, :live_view

  import Ecto.Query

  @impl true
  def mount(_params, session, socket) do
    query =
      from m in MediaServer.Movies,
        order_by: [asc: m.id],
        limit: 25

    {
      :ok,
      socket
      |> assign(
        :current_user,
        MediaServer.Accounts.get_user_by_session_token(session["user_token"])
      )
      |> assign(:page_title, "Movies")
      |> assign(query: query)
    }
  end

  @impl true
  def handle_params(%{"genre" => genre, "page" => page}, _url, socket) do
    capitalized_genre = String.capitalize(genre)

    movies =
      Scrivener.paginate(
        MediaServer.MoviesIndex.all() |> MediaServer.MoviesIndex.genre(capitalized_genre),
        %{
          "page" => page,
          "page_size" => "50"
        }
      )

    {
      :noreply,
      socket
      |> assign(:page_title, "Movies - #{capitalized_genre}")
      |> assign(:movies, movies)
      |> assign(
        :previous_link,
        ~p"/movies?genre=#{genre}&page=#{MediaServerWeb.Helpers.get_pagination_previous_link(movies.page_number)}"
      )
      |> assign(
        :next_link,
        ~p"/movies?genre=#{genre}&page=#{MediaServerWeb.Helpers.get_pagination_next_link(movies.page_number)}"
      )
    }
  end

  def handle_params(%{"genre" => genre}, _url, socket) do
    capitalized_genre = String.capitalize(genre)

    movies =
      Scrivener.paginate(
        MediaServer.MoviesIndex.all() |> MediaServer.MoviesIndex.genre(capitalized_genre),
        %{
          "page" => "1",
          "page_size" => "50"
        }
      )

    {
      :noreply,
      socket
      |> assign(:page_title, "Movies - #{capitalized_genre}")
      |> assign(:movies, movies)
      |> assign(
        :previous_link,
        ~p"/movies?genre=#{genre}&page=#{MediaServerWeb.Helpers.get_pagination_previous_link(movies.page_number)}"
      )
      |> assign(
        :next_link,
        ~p"/movies?genre=#{genre}&page=#{MediaServerWeb.Helpers.get_pagination_next_link(movies.page_number)}"
      )
    }
  end

  def handle_params(%{"sort_by" => "latest", "page" => page}, _url, socket) do
    movies =
      Scrivener.paginate(MediaServer.MoviesIndex.all() |> MediaServer.MoviesIndex.latest(), %{
        "page" => page,
        "page_size" => "50"
      })

    {
      :noreply,
      socket
      |> assign(:page_title, "Movies - Latest")
      |> assign(:movies, movies)
      |> assign(
        :previous_link,
        ~p"/movies?sort_by=latest&page=#{MediaServerWeb.Helpers.get_pagination_previous_link(movies.page_number)}"
      )
      |> assign(
        :next_link,
        ~p"/movies?sort_by=latest&page=#{MediaServerWeb.Helpers.get_pagination_next_link(movies.page_number)}"
      )
    }
  end

  def handle_params(%{"sort_by" => "latest"}, _url, socket) do
    movies =
      Scrivener.paginate(MediaServer.MoviesIndex.all() |> MediaServer.MoviesIndex.latest(), %{
        "page" => "1",
        "page_size" => "50"
      })

    {
      :noreply,
      socket
      |> assign(:page_title, "Movies - Latest")
      |> assign(:movies, movies)
      |> assign(
        :previous_link,
        ~p"/movies?sort_by=latest&page=#{MediaServerWeb.Helpers.get_pagination_previous_link(movies.page_number)}"
      )
      |> assign(
        :next_link,
        ~p"/movies?sort_by=latest&page=#{MediaServerWeb.Helpers.get_pagination_next_link(movies.page_number)}"
      )
    }
  end

  def handle_params(%{"filter_by" => "upcoming"}, _url, socket) do
    movies =
      Scrivener.paginate(MediaServer.MoviesIndex.all() |> MediaServer.MoviesIndex.upcoming(), %{
        "page" => "1",
        "page_size" => "50"
      })

    {
      :noreply,
      socket
      |> assign(:page_title, "Movies - Upcoming")
      |> assign(:movies, movies)
      |> assign(
        :previous_link,
        ~p"/movies?sort_by=upcoming&page=#{MediaServerWeb.Helpers.get_pagination_previous_link(movies.page_number)}"
      )
      |> assign(
        :next_link,
        ~p"/movies?sort_by=upcoming&page=#{MediaServerWeb.Helpers.get_pagination_next_link(movies.page_number)}"
      )
    }
  end

  def handle_params(%{"page" => page}, _url, socket) do
    movies =
      Scrivener.paginate(MediaServer.MoviesIndex.all(), %{
        "page" => page,
        "page_size" => "50"
      })

    {
      :noreply,
      socket
      |> assign(:page_title, "Movies")
      |> assign(:movies, movies)
      |> assign(
        :previous_link,
        ~p"/movies?page=#{MediaServerWeb.Helpers.get_pagination_previous_link(movies.page_number)}"
      )
      |> assign(
        :next_link,
        ~p"/movies?page=#{MediaServerWeb.Helpers.get_pagination_next_link(movies.page_number)}"
      )
    }
  end

  def handle_params(_params, _url, socket) do
    movies =
      Scrivener.paginate(MediaServer.MoviesIndex.all(), %{
        "page" => "1",
        "page_size" => "50"
      })

    {
      :noreply,
      socket
      |> assign(:page_title, "Movies")
      |> assign(:movies, movies)
      |> assign(
        :previous_link,
        ~p"/movies?page=#{MediaServerWeb.Helpers.get_pagination_previous_link(movies.page_number)}"
      )
      |> assign(
        :next_link,
        ~p"/movies?page=#{MediaServerWeb.Helpers.get_pagination_next_link(movies.page_number)}"
      )
    }
  end
end
