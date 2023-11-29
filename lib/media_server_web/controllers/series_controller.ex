defmodule MediaServerWeb.SeriesController do
  use MediaServerWeb, :controller

  def index(conn, %{"page" => page}) do
    series =
      Scrivener.paginate(MediaServer.SeriesIndex.all(), %{
        "page" => page,
        "page_size" => "50"
      })

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(
      200,
      Jason.encode!(%{
        "total" => series.total_entries,
        "items" =>
          Enum.map(series.entries, fn x ->
            %{
              "title" => x["title"],
              "overview" => x["overview"],
              "year" => x["year"],
              "seasonCount" => x["statistics"]["seasonCount"],
              "poster" => ~p"/api/images?series=#{x["id"]}&type=poster",
              "background" => ~p"/api/images?series=#{x["id"]}&type=background",
              "stream" => ~p"/api/stream?series=#{x["id"]}"
            }
          end),
        "prev_page" =>
          ~p"/api/series?page=#{MediaServerWeb.Helpers.get_pagination_previous_link(series.page_number)}",
        "next_page" =>
          ~p"/api/series?page=#{MediaServerWeb.Helpers.get_pagination_next_link(series.page_number)}"
      })
    )
  end

  def index(conn, _params) do
    series =
      Scrivener.paginate(MediaServer.SeriesIndex.all(), %{
        "page" => "1",
        "page_size" => "50"
      })

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(
      200,
      Jason.encode!(%{
        "total" => series.total_entries,
        "items" =>
          Enum.map(series.entries, fn x ->
            %{
              "title" => x["title"],
              "overview" => x["overview"],
              "year" => x["year"],
              "seasonCount" => x["statistics"]["seasonCount"],
              "poster" => ~p"/api/images?series=#{x["id"]}&type=poster",
              "background" => ~p"/api/images?series=#{x["id"]}&type=background",
              "stream" => ~p"/api/stream?series=#{x["id"]}"
            }
          end),
        "prev_page" =>
          ~p"/api/series?page=#{MediaServerWeb.Helpers.get_pagination_previous_link(series.page_number)}",
        "next_page" =>
          ~p"/api/series?page=#{MediaServerWeb.Helpers.get_pagination_next_link(series.page_number)}"
      })
    )
  end
end
