defmodule MediaServerWeb.MoviesController do
  use MediaServerWeb, :controller

  def index(conn, %{"genre" => genre, "page" => page}) do
    capitalized_genre = String.capitalize(genre)

    movies =
      Scrivener.paginate(
        MediaServer.MoviesIndex.genre(MediaServer.MoviesIndex.all(), capitalized_genre),
        %{
          "page" => page,
          "page_size" => "50"
        }
      )

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(
      200,
      Jason.encode!(%{
        "total" => movies.total_entries,
        "items" =>
          Enum.map(movies.entries, fn x ->
            %{
              "title" => x["title"],
              "overview" => x["overview"],
              "year" => x["year"],
              "poster" => ~p"/api/images?movie=#{ x["id"] }&type=poster",
              "background" => ~p"/api/images?movie=#{ x["id"] }&type=background",
              "stream" => ~p"/api/stream?movie=#{ x["id"] }"
            }
          end),
        "prev_page" =>
          ~p"/api/movies?page=#{MediaServerWeb.Helpers.get_pagination_previous_link(movies.page_number)}",
        "next_page" =>
          ~p"/api/movies?page=#{MediaServerWeb.Helpers.get_pagination_next_link(movies.page_number)}"
      })
    )
  end

  def index(conn, %{"genre" => genre}) do
    capitalized_genre = String.capitalize(genre)

    movies =
      Scrivener.paginate(
        MediaServer.MoviesIndex.genre(MediaServer.MoviesIndex.all(), capitalized_genre),
        %{
          "page" => "1",
          "page_size" => "50"
        }
      )

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(
      200,
      Jason.encode!(%{
        "total" => movies.total_entries,
        "items" =>
          Enum.map(movies.entries, fn x ->
            %{
              "title" => x["title"],
              "overview" => x["overview"],
              "year" => x["year"],
              "poster" => ~p"/api/images?movie=#{ x["id"] }&type=poster",
              "background" => ~p"/api/images?movie=#{ x["id"] }&type=background",
              "stream" => ~p"/api/stream?movie=#{ x["id"] }"
            }
          end),
        "prev_page" =>
          ~p"/api/movies?page=#{MediaServerWeb.Helpers.get_pagination_previous_link(movies.page_number)}",
        "next_page" =>
          ~p"/api/movies?page=#{MediaServerWeb.Helpers.get_pagination_next_link(movies.page_number)}"
      })
    )
  end

  def index(conn, %{"sort_by" => "latest", "page" => page}) do
    movies =
      Scrivener.paginate(MediaServer.MoviesIndex.latest(MediaServer.MoviesIndex.all()), %{
        "page" => page,
        "page_size" => "50"
      })

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(
      200,
      Jason.encode!(%{
        "total" => movies.total_entries,
        "items" =>
          Enum.map(movies.entries, fn x ->
            %{
              "title" => x["title"],
              "overview" => x["overview"],
              "year" => x["year"],
              "poster" => ~p"/api/images?movie=#{ x["id"] }&type=poster",
              "background" => ~p"/api/images?movie=#{ x["id"] }&type=background",
              "stream" => ~p"/api/stream?movie=#{ x["id"] }"
            }
          end),
        "prev_page" =>
          ~p"/api/movies?page=#{MediaServerWeb.Helpers.get_pagination_previous_link(movies.page_number)}",
        "next_page" =>
          ~p"/api/movies?page=#{MediaServerWeb.Helpers.get_pagination_next_link(movies.page_number)}"
      })
    )
  end

  def index(conn, %{"sort_by" => "latest"}) do
    movies =
      Scrivener.paginate(MediaServer.MoviesIndex.latest(MediaServer.MoviesIndex.all()), %{
        "page" => "1",
        "page_size" => "50"
      })

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(
      200,
      Jason.encode!(%{
        "total" => movies.total_entries,
        "items" =>
          Enum.map(movies.entries, fn x ->
            %{
              "title" => x["title"],
              "overview" => x["overview"],
              "year" => x["year"],
              "poster" => ~p"/api/images?movie=#{ x["id"] }&type=poster",
              "background" => ~p"/api/images?movie=#{ x["id"] }&type=background",
              "stream" => ~p"/api/stream?movie=#{ x["id"] }"
            }
          end),
        "prev_page" =>
          ~p"/api/movies?page=#{MediaServerWeb.Helpers.get_pagination_previous_link(movies.page_number)}",
        "next_page" =>
          ~p"/api/movies?page=#{MediaServerWeb.Helpers.get_pagination_next_link(movies.page_number)}"
      })
    )
  end

  def index(conn, %{"page" => page}) do
    movies =
      Scrivener.paginate(MediaServer.MoviesIndex.all(), %{
        "page" => page,
        "page_size" => "50"
      })

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(
      200,
      Jason.encode!(%{
        "total" => movies.total_entries,
        "items" =>
          Enum.map(movies.entries, fn x ->
            %{
              "title" => x["title"],
              "overview" => x["overview"],
              "year" => x["year"],
              "poster" => ~p"/api/images?movie=#{ x["id"] }&type=poster",
              "background" => ~p"/api/images?movie=#{ x["id"] }&type=background",
              "stream" => ~p"/api/stream?movie=#{ x["id"] }"
            }
          end),
        "prev_page" =>
          ~p"/api/movies?page=#{MediaServerWeb.Helpers.get_pagination_previous_link(movies.page_number)}",
        "next_page" =>
          ~p"/api/movies?page=#{MediaServerWeb.Helpers.get_pagination_next_link(movies.page_number)}"
      })
    )
  end

  def index(conn, _params) do
    movies =
      Scrivener.paginate(MediaServer.MoviesIndex.all(), %{
        "page" => "1",
        "page_size" => "50"
      })

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(
      200,
      Jason.encode!(%{
        "total" => movies.total_entries,
        "items" =>
          Enum.map(movies.entries, fn x ->
            %{
              "title" => x["title"],
              "overview" => x["overview"],
              "year" => x["year"],
              "poster" => ~p"/api/images?movie=#{ x["id"] }&type=poster",
              "background" => ~p"/api/images?movie=#{ x["id"] }&type=background",
              "stream" => ~p"/api/stream?movie=#{ x["id"] }"
            }
          end),
        "prev_page" =>
          ~p"/api/movies?page=#{MediaServerWeb.Helpers.get_pagination_previous_link(movies.page_number)}",
        "next_page" =>
          ~p"/api/movies?page=#{MediaServerWeb.Helpers.get_pagination_next_link(movies.page_number)}"
      })
    )
  end
end
