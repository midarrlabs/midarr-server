defmodule MediaServer.AudioInserter do
  use Oban.Worker, queue: :default, max_attempts: 3

  @impl true
  def perform(%Oban.Job{args: %{"record" => record}}) do
    movie = MediaServer.MoviesIndex.find(MediaServer.MoviesIndex.all(), record.external_id)

    duration = Exile.stream!([
      "ffprobe",
      "-v", "error",
      "-show_entries", "format=duration",
      "-select_streams", "a",
      "-of", "csv=p=0",
      movie["movieFile"]["path"]
    ])
    |> Enum.at(0)
    |> String.trim()
    |> String.to_float()

    MediaServer.MediaAudio.insert_record(%{
        media_id: record.id,
        duration: duration
      })

    :ok
  end
end
