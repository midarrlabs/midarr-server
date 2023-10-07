defmodule MediaServer.UserActions do
  use GenServer

  require Logger

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Phoenix.PubSub.subscribe(MediaServer.PubSub, "user")

    {:ok, state}
  end

  def handle_info({:registered, _params}, state) do
    {:noreply, state}
  end

  def handle_info({:navigated, params}, state) do
    Logger.info(params)

    {:noreply, state}
  end

  def handle_info({:followed, params}, state) do

    media_type_id = MediaServer.MediaTypes.get_type_id(params["media_type"])

    MediaServer.MediaActions.create(%{
      media_id: params["media_id"],
      user_id: params["user_id"],
      action_id: MediaServer.Actions.get_followed_id(),
      media_type_id: media_type_id
    })

    Logger.info("user_id:#{ params["user_id"] }:followed:media_type_id:#{ media_type_id }:media_id:#{ params["media_id"] }")

    {:noreply, state}
  end

  def handle_info({:unfollowed, params}, state) do

    media_type_id = MediaServer.MediaTypes.get_type_id(params["media_type"])

    MediaServer.MediaActions.delete(%{
      media_id: params["media_id"],
      user_id: params["user_id"],
      action_id: MediaServer.Actions.get_followed_id(),
      media_type_id: media_type_id
    })

    Logger.info("user_id:#{ params["user_id"] }:unfollowed:media_type_id:#{ media_type_id }:media_id:#{ params["media_id"] }")

    {:noreply, state}
  end

  def handle_info({:granted_push_notifications, params}, state) do

    MediaServer.PushSubscriptions.create(%{
      user_id: params["user_id"],
      push_subscription: params["push_subscription"]
    })

    Logger.info("user_id:#{ params["user_id"] }:granted_push_notifications:media_type_id:#{ params["media_type_id"] }:media_id:#{ params["media_id"] }")

    {:noreply, state}
  end

  def handle_info({:denied_push_notifications, params}, state) do

    MediaServer.PushSubscriptions.create(%{
      user_id: params["user_id"],
      push_subscription: params["message"]
    })

    Logger.info("user_id:#{ params["user_id"] }:denied_push_notifications:media_type_id:#{ params["media_type_id"] }:media_id:#{ params["media_id"] }")

    {:noreply, state}
  end
end
