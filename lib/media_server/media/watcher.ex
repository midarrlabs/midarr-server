defmodule MediaServer.Media.Watcher do
  use GenServer

  alias MediaServer.Media

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(args) do
    {:ok, pid} = FileSystem.start_link(args)

    FileSystem.subscribe(pid)
    
    {:ok, %{pid: pid}}
  end

  def handle_info({:file_event, pid, {path, events}}, %{pid: pid} = state) do

    if events == [:created] do

      if String.contains?(path, ".mp4") do
            IO.inspect path
            IO.inspect events

            Media.Util.persist_file(path)
      end
    end
    
    {:noreply, state}
  end

  def handle_info({:file_event, pid, :stop}, %{pid: pid} = state) do
    # Your own logic when monitor stop
    {:noreply, state}
  end
end