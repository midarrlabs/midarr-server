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

  def handle_info({:registered, _user}, state) do
    {:noreply, state}
  end

  def handle_info({:navigated, url}, state) do
    Logger.info(url)

    {:noreply, state}
  end

  def handle_info({:followed, media}, state) do
    MediaServer.MediaActions.insert_or_update(%{
      media_id: media["media_id"],
      user_id: media["user_id"],
      action_id: MediaServer.Actions.get_followed_id(),
      media_type_id: MediaServer.MediaTypes.get_type_id(media["media_type"])
    })

    {:noreply, state}
  end
end
