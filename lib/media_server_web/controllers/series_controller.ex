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
              "id" => x["id"],
              "title" => x["title"],
              "overview" => x["overview"],
              "year" => x["year"],
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
              "id" => x["id"],
              "title" => x["title"],
              "overview" => x["overview"],
              "year" => x["year"],
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

  def show(conn, %{"id" => id, "season" => season}) do
    series = MediaServer.SeriesIndex.all() |> MediaServer.SeriesIndex.find(id)

    episodes = MediaServerWeb.Repositories.Episodes.get_all(series["id"], season)

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(
         200,
         Jason.encode!(
           Enum.map(episodes, fn episode ->
             %{
               "title" => episode["title"],
               "overview" => episode["overview"],
               "screenshot" => ~p"/api/images?episode=#{episode["id"]}&type=screenshot",
             }
         end))
       )
  end

  def show(conn, %{"id" => id}) do
    series = MediaServer.SeriesIndex.all() |> MediaServer.SeriesIndex.find(id)

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(
         200,
         Jason.encode!(%{
           "id" => series["id"],
           "title" => series["title"],
           "overview" => series["overview"],
           "year" => series["year"],
           "seasonCount" => series["statistics"]["seasonCount"],
           "poster" => ~p"/api/images?series=#{series["id"]}&type=poster",
           "background" => ~p"/api/images?series=#{series["id"]}&type=background",
           "stream" => ~p"/api/stream?series=#{series["id"]}"
         })
       )
  end
end
