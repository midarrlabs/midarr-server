defmodule MediaServerWeb.SeriesController do
  use MediaServerWeb, :controller

  def index(conn, params) do
    {:ok, {series, meta}} = Flop.validate_and_run(MediaServer.Series, params)

    conn
    |> json(%{
        data: series,
        meta: %{
          total_pages: meta.total_pages,
          total_count: meta.total_count,
          has_next_page: meta.has_next_page?,
          has_previous_page: meta.has_previous_page?,
          previous_page: meta.previous_page,
          next_page: meta.next_page,
          current_page: meta.current_page,
        }
      })
  end

  def show(conn, %{"id" => id}) do
    series = MediaServer.Repo.get(MediaServer.Series, id)

    conn
    |> json(series)
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
               "stream" => ~p"/api/stream?episode=#{episode["id"]}"
             }
         end))
       )
  end
end
