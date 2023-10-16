defmodule MediaServerWeb.WebhooksController do
  use MediaServerWeb, :controller

  def create(conn, %{"id" => "movie", "eventType" => "Download"} = params) do
    MediaServer.MovieActions.handle_info({:added, params})

    conn
    |> send_resp(201, "Ok")
  end

  def create(conn, %{"id" => "movie", "eventType" => "MovieDelete"}) do
    MediaServer.MovieActions.handle_info({:deleted})

    conn
    |> send_resp(201, "Ok")
  end

  def create(conn, %{"id" => "movie", "eventType" => "MovieFileDelete"}) do
    MediaServer.MovieActions.handle_info({:deleted_file})

    conn
    |> send_resp(201, "Ok")
  end

  def create(conn, %{"id" => "series", "eventType" => "Download"} = params) do
    MediaServer.SeriesActions.handle_info({:added, params})

    conn
    |> send_resp(201, "Ok")
  end

  def create(conn, %{"id" => "series", "eventType" => "SeriesDelete"}) do
    MediaServer.SeriesActions.handle_info({:deleted})

    conn
    |> send_resp(201, "Ok")
  end

  def create(conn, %{"id" => "series", "eventType" => "EpisodeFileDelete"}) do
    MediaServer.SeriesActions.handle_info({:deleted_episode_file})

    conn
    |> send_resp(201, "Ok")
  end

  def create(conn, _payload) do
    conn
    |> send_resp(200, "Ok")
  end
end
