defmodule MediaServerWeb.UserNavigation do
  def on_mount(:get_request_uri, _params, _session, socket) do
    {:cont, Phoenix.LiveView.attach_hook(socket, :get_request_path, :handle_params, &get_request_path/3)}
  end

  defp get_request_path(_params, url, socket) do
    IO.puts "#{ socket.assigns.current_user.name }: #{ url }"

    {:cont, socket}
  end
end