defmodule MediaServerWeb.UserNavigation do
  import Phoenix.LiveView
  import Phoenix.Component

  def on_mount(:default, _params, _session, socket) do
    {:cont,
      socket
      |> attach_hook(:handle, :handle_params, &handle/3)}
  end

  defp handle(_params, request_path, socket) do
    Phoenix.PubSub.broadcast(
      MediaServer.PubSub,
      "user",
      {:navigated, "#{socket.assigns.current_user.name}: #{request_path}"}
    )

    {:cont, socket |> assign(request_path: request_path)}
  end
end
