defmodule MediaServerWeb.SearchController do
  use MediaServerWeb, :controller

  def index(conn, %{"query" => query}) do
    movies =
      Scrivener.paginate(
        MediaServer.MoviesIndex.search(MediaServer.MoviesIndex.all(), query),
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
                                           "poster" => ~p"/api/images?movie=#{x["id"]}&type=poster",
                                           "background" => ~p"/api/images?movie=#{x["id"]}&type=background",
                                           "stream" => ~p"/api/stream?movie=#{x["id"]}"
                                         }
             end)
         })
       )
  end
end
