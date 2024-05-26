defmodule MediaServerWeb.Actions.User do
  require Logger

  def handle_info({:registered, _params}) do
  end

  def handle_info({:navigated, params}) do
    Logger.info(params)
  end

  def handle_info({:followed, params}) do
    MediaServer.MediaActions.create(%{
      media_id: params["media_id"],
      user_id: params["user_id"],
      action_id: MediaServer.Actions.get_followed_id()
    })

    Logger.info(
      "user_id:#{params["user_id"]}:followed:media_id:#{params["media_id"]}"
    )
  end

  def handle_info({:unfollowed, params}) do
    MediaServer.MediaActions.delete(%{
      media_id: params["media_id"],
      user_id: params["user_id"],
      action_id: MediaServer.Actions.get_followed_id()
    })

    Logger.info(
      "user_id:#{params["user_id"]}:unfollowed:media_id:#{params["media_id"]}"
    )
  end

  def handle_info({:granted_push_notifications, params}) do
    MediaServer.PushSubscriptions.create(%{
      user_id: params["user_id"],
      push_subscription: params["push_subscription"]
    })

    Logger.info(
      "user_id:#{params["user_id"]}:granted_push_notifications:media_id:#{params["media_id"]}"
    )
  end

  def handle_info({:denied_push_notifications, params}) do
    MediaServer.PushSubscriptions.create(%{
      user_id: params["user_id"],
      push_subscription: params["message"]
    })

    Logger.info(
      "user_id:#{params["user_id"]}:denied_push_notifications:media_id:#{params["media_id"]}"
    )
  end
end
