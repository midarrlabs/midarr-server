defmodule MediaServerWeb.MoviesLive.Index do
  use MediaServerWeb, :live_view

  alias Phoenix.LiveView.JS

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(:page_title, "Movies")
    }
  end

  @impl true
  def handle_params(%{"genre" => genre, "page" => page}, _url, socket) do

    capitalized_genre = String.capitalize(genre)

    movies = Scrivener.paginate(MediaServer.MoviesIndex.get_genre(capitalized_genre), %{
      "page" => page,
      "page_size" => "50"
    })

    previous_link = Routes.movies_index_path(socket, :index,
      genre: genre,
      page: MediaServerWeb.Helpers.get_pagination_previous_link(movies.page_number)
    )

    next_link = Routes.movies_index_path(socket, :index,
      genre: genre,
      page: MediaServerWeb.Helpers.get_pagination_next_link(movies.page_number)
    )

    {
      :noreply,
      socket
      |> assign(:page_title, "Movies - #{ capitalized_genre }")
      |> assign(:movies, movies)
      |> assign(:previous_link, previous_link)
      |> assign(:next_link, next_link)
      |> assign(:genre, genre)
    }
  end

  def handle_params(%{"genre" => genre}, _url, socket) do

    capitalized_genre = String.capitalize(genre)

    movies = Scrivener.paginate(MediaServer.MoviesIndex.get_genre(capitalized_genre), %{
      "page" => "1",
      "page_size" => "50"
    })

    previous_link = Routes.movies_index_path(socket, :index,
      genre: genre,
      page: MediaServerWeb.Helpers.get_pagination_previous_link(movies.page_number)
    )

    next_link = Routes.movies_index_path(socket, :index,
      genre: genre,
      page: MediaServerWeb.Helpers.get_pagination_next_link(movies.page_number)
    )

    {
      :noreply,
      socket
      |> assign(:page_title, "Movies - #{ capitalized_genre }")
      |> assign(:movies, movies)
      |> assign(:previous_link, previous_link)
      |> assign(:next_link, next_link)
      |> assign(:genre, genre)
    }
  end

  def handle_params(%{"sort_by" => "latest", "page" => page}, _url, socket) do

    movies = Scrivener.paginate(MediaServer.MoviesIndex.get_latest(), %{
      "page" => page,
      "page_size" => "50"
    })

    previous_link = Routes.movies_index_path(socket, :index,
      sort_by: "latest",
      page: MediaServerWeb.Helpers.get_pagination_previous_link(movies.page_number)
    )

    next_link = Routes.movies_index_path(socket, :index,
      sort_by: "latest",
      page: MediaServerWeb.Helpers.get_pagination_next_link(movies.page_number)
    )

    {
      :noreply,
      socket
      |> assign(:page_title, "Movies - Latest")
      |> assign(:movies, movies)
      |> assign(:previous_link, previous_link)
      |> assign(:next_link, next_link)
      |> assign(:genre, "latest")
    }
  end

  def handle_params(%{"sort_by" => "latest"}, _url, socket) do

    movies = Scrivener.paginate(MediaServer.MoviesIndex.get_latest(), %{
      "page" => "1",
      "page_size" => "50"
    })

    previous_link = Routes.movies_index_path(socket, :index,
      sort_by: "latest",
      page: MediaServerWeb.Helpers.get_pagination_previous_link(movies.page_number)
    )

    next_link = Routes.movies_index_path(socket, :index,
      sort_by: "latest",
      page: MediaServerWeb.Helpers.get_pagination_next_link(movies.page_number)
    )

    {
      :noreply,
      socket
      |> assign(:page_title, "Movies - Latest")
      |> assign(:movies, movies)
      |> assign(:previous_link, previous_link)
      |> assign(:next_link, next_link)
      |> assign(:genre, "latest")
    }
  end

  def handle_params(%{"page" => page}, _url, socket) do

    movies = Scrivener.paginate(MediaServer.MoviesIndex.get_all(), %{
      "page" => page,
      "page_size" => "50"
    })

    previous_link = Routes.movies_index_path(socket, :index,
      page: MediaServerWeb.Helpers.get_pagination_previous_link(movies.page_number)
    )

    next_link = Routes.movies_index_path(socket, :index,
      page: MediaServerWeb.Helpers.get_pagination_next_link(movies.page_number)
    )

    {
      :noreply,
      socket
      |> assign(:movies, movies)
      |> assign(:previous_link, previous_link)
      |> assign(:next_link, next_link)
      |> assign(:genre, "A-Z")
    }
  end

  def handle_params(_params, _url, socket) do

    movies = Scrivener.paginate(MediaServer.MoviesIndex.get_all(), %{
      "page" => "1",
      "page_size" => "50"
    })

    previous_link = Routes.movies_index_path(socket, :index,
      page: MediaServerWeb.Helpers.get_pagination_previous_link(movies.page_number)
    )

    next_link = Routes.movies_index_path(socket, :index,
      page: MediaServerWeb.Helpers.get_pagination_next_link(movies.page_number)
    )

    {
      :noreply,
      socket
      |> assign(:movies, movies)
      |> assign(:previous_link, previous_link)
      |> assign(:next_link, next_link)
      |> assign(:genre, "A-Z")
    }
  end
end
