defmodule MediaServerWeb.WebhooksController do
  use MediaServerWeb, :controller

  def create(conn, %{"id" => "movie", "eventType" => "Download"}) do
    Phoenix.PubSub.broadcast(MediaServer.PubSub, "movie", {:added})

    conn
    |> send_resp(201, "Ok")
  end

  def create(conn, %{"id" => "movie", "eventType" => "MovieDelete"}) do
    Phoenix.PubSub.broadcast(MediaServer.PubSub, "movie", {:deleted})

    conn
    |> send_resp(201, "Ok")
  end

  def create(conn, %{"id" => "movie", "eventType" => "MovieFileDelete"}) do
    Phoenix.PubSub.broadcast(MediaServer.PubSub, "movie", {:deleted_file})

    conn
    |> send_resp(201, "Ok")
  end

  def create(conn, %{"id" => "series", "eventType" => "Download"}) do
    Phoenix.PubSub.broadcast(MediaServer.PubSub, "series", {:added})

    conn
    |> send_resp(201, "Ok")
  end

  def create(conn, %{"id" => "series", "eventType" => "SeriesDelete"}) do
    Phoenix.PubSub.broadcast(MediaServer.PubSub, "series", {:deleted})

    conn
    |> send_resp(201, "Ok")
  end

  def create(conn, %{"id" => "series", "eventType" => "EpisodeFileDelete"}) do
    Phoenix.PubSub.broadcast(MediaServer.PubSub, "series", {:deleted_episode_file})

    conn
    |> send_resp(201, "Ok")
  end

  def create(conn, _payload) do
    conn
    |> send_resp(200, "Ok")
  end
end
