defmodule MediaServerWeb.StreamLive.Show do
  use MediaServerWeb, :live_view

  alias MediaServer.Media

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    file = Media.get_file!(id)

    {:noreply,
     socket
     |> assign(:file, file)
     |> assign(:page_title, "#{file.title}")
     }
  end

  @impl true
  def handle_event("publish_stream", _, socket) do
    uuid = Ecto.UUID.generate

    task = Task.async(fn ->
      Rambo.run(System.find_executable("ffmpeg"), ["-readrate", "1.5", "-i", "#{socket.assigns.file.path}", "-map", "0:0", "-map", "0:1", "-c:v", "libx264", "-preset", "veryfast", "-b:v", "3000k", "-maxrate", "3000k", "-bufsize", "6000k", "-pix_fmt", "yuv420p", "-g", "50", "-c:a:1", "acc", "-b:a", "160k", "-ac", "2", "-ar", "44100", "-f", "rtsp", "-rtsp_transport", "tcp", "#{System.get_env("RTSP_SERVER_URL") || "rtsp://rtsp-simple-server:8554"}/#{uuid}"])
    end)

    {:noreply, push_event(
      socket 
      |> assign(:task, task)
      |> assign(:uuid, uuid), "stream_published", %{uuid: uuid})}
  end

  @impl true
  def handle_event("unpublish_stream", _, socket) do
    Rambo.kill(socket.assigns.task.pid)

    {:noreply, socket}
  end
end
