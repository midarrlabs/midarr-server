defmodule MediaServer.MovieActions do
  use Task

  def start_link(arg) do
    Task.start_link(__MODULE__, :run, [arg])
  end

  def run(_arg) do
    Phoenix.PubSub.subscribe(MediaServer.PubSub, "movie")
  end

  def handle_info({:added, %{"movie" => %{"id" => id, "title" => title}}}) do
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
  end

  def handle_info({:deleted}) do
    MediaServer.MoviesIndex.reset()
  end

  def handle_info({:deleted_file}) do
    MediaServer.MoviesIndex.reset()
  end
end
