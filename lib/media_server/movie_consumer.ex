defmodule MediaServer.MovieConsumer do
  use GenStage

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_opts), do: {:consumer, [], subscribe_to: [MediaServer.MediaProducer]}

  def handle_events(events, _from, state) do
    new_state = state ++ Enum.map(events, fn event -> %{
      id: event["id"],
      title: event["title"],
      overview: event["overview"],
      run_time: event["movieFile"]["mediaInfo"]["runTime"],
      genres: event["genres"],
      has_file: event["hasFile"],
      images: event["images"],
      folder_name: event["folderName"],
      relative_path: event["movieFile"]["relativePath"],
      path: event["movieFile"]["path"],
      date_added: event["movieFile"]["dateAdded"],
      monitored: event["monitored"],
    } end)

    {:noreply, [], new_state |> Enum.reverse()}
  end

  def handle_call({:all}, _from, state) do
    {:reply, state, [], state}
  end
end
