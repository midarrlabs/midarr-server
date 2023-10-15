defmodule MediaServer.SeriesActions do
  use Task

  require Logger

  def start_link(arg) do
    Task.start_link(__MODULE__, :run, [arg])
  end

  def run(_arg) do
    Phoenix.PubSub.subscribe(MediaServer.PubSub, "series")
  end

  def handle_info({:added, %{"series" => %{"id" => id, "title" => title}}}) do
    MediaServer.SeriesIndex.reset()

    followers = MediaServer.MediaActions.series(id) |> MediaServer.MediaActions.followers()

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
    MediaServer.SeriesIndex.reset()
  end

  def handle_info({:deleted_episode_file}) do
    MediaServer.SeriesIndex.reset()
  end
end
