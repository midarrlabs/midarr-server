defmodule MediaServerWeb.WebhooksController do
  use MediaServerWeb, :controller

  def create(conn, %{
        "id" => "movie",
        "eventType" => "Download",
        "movie" => %{"id" => id, "title" => title}
      }) do
    MediaServer.MoviesIndex.reset()

    followers = MediaServer.MediaActions.movie(id) |> MediaServer.MediaActions.followers()

    Enum.each(followers, fn media_action ->
      Enum.each(media_action.user.push_subscriptions, fn push_subscription ->
        WebPushElixir.send_notification(
          push_subscription.push_subscription,
          "#{title} is now available"
        )
      end)
    end)

    conn
    |> send_resp(201, "Ok")
  end

  def create(conn, %{"id" => "movie", "eventType" => "MovieDelete"}) do
    MediaServer.MoviesIndex.reset()

    conn
    |> send_resp(201, "Ok")
  end

  def create(conn, %{"id" => "movie", "eventType" => "MovieFileDelete"}) do
    MediaServer.MoviesIndex.reset()

    conn
    |> send_resp(201, "Ok")
  end

  def create(conn, %{"id" => "series", "eventType" => "Download"} = params) do
    Phoenix.PubSub.broadcast(MediaServer.PubSub, "series", {:added, params})

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
