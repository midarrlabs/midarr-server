defmodule MediaServerWeb.StreamController do
  use MediaServerWeb, :controller

  import MediaServerWeb.Util
  import FFmpex
  use FFmpex.Options

  alias MediaServer.Media

  def show(%{req_headers: headers} = conn, %{"id" => id}) do

    file = Media.get_file!(id)

    if String.contains?(file.path, ".mkv") and !File.exists?("/copies/#{id}.mp4") do

      command =
        FFmpex.new_command
        |> add_input_file(file.path)
        |> add_output_file("/copies/#{id}.mp4")
          |> add_stream_specifier(stream_type: :video)
            |> add_stream_option(option_codec("copy"))

      execute(command)
    end

    if File.exists?("/copies/#{id}.mp4") do
      send_video(conn, headers, "/copies/#{id}.mp4")
      
    else
      send_video(conn, headers, file.path)
  end
end