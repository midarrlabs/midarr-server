defmodule MediaServerWeb.Components.FollowComponent do
  use MediaServerWeb, :live_component

  import Ecto.Query

  @impl true
  def preload(list_of_assigns) do
    media_id = Enum.find(list_of_assigns, fn assign -> Map.get(assign, :media_id) end).media_id
    media_type = Enum.find(list_of_assigns, fn assign -> Map.get(assign, :media_type) end).media_type
    user_id = Enum.find(list_of_assigns, fn assign -> Map.get(assign, :user_id) end).user_id

    media_type_id = MediaServer.MediaTypes.get_type_id(media_type)

    query =
      from media_actions in MediaServer.MediaActions,
           where:
             media_actions.media_type_id == ^media_type_id and
             media_actions.user_id == ^user_id and media_actions.media_id == ^media_id and media_actions.action_id == ^MediaServer.Actions.get_followed_id

    result = MediaServer.Repo.all(query)

    Enum.map(list_of_assigns, fn assign ->
      if Enum.count(result) === 0 do
        %{
          state: "Follow",
          event: "follow"
        }
      else
        %{
          state: "Following",
          event: "unfollow"
        }
      end |> Map.merge(%{
        media_id: assign.media_id,
        media_type: assign.media_type,
        user_id: assign.user_id,
        return_to: assign.return_to
      })
    end)
  end

  @impl true
  def handle_event("follow", params, socket) do
    Phoenix.PubSub.broadcast(MediaServer.PubSub, "user", {:followed, params})

    {
      :noreply,
      socket
      |> push_navigate(to: socket.assigns.return_to)
    }
  end

  def handle_event("unfollow", params, socket) do
    Phoenix.PubSub.broadcast(MediaServer.PubSub, "user", {:unfollowed, params})

    {
      :noreply,
      socket
      |> push_navigate(to: socket.assigns.return_to)
    }
  end

  def handle_event("grant_push_notifications", params, socket) do
    Phoenix.PubSub.broadcast(MediaServer.PubSub, "user", {:granted_push_notifications, params})

    {:noreply, socket}
  end

  def handle_event("deny_push_notifications", params, socket) do
    Phoenix.PubSub.broadcast(MediaServer.PubSub, "user", {:denied_push_notifications, params})

    {:noreply, socket}
  end
end
