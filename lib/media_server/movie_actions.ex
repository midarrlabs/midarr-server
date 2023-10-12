defmodule MediaServer.MovieActions do
  use GenServer

  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(_opts) do
    Phoenix.PubSub.subscribe(MediaServer.PubSub, "movie")

    {:ok, %{}}
  end

  defp notify_followers(state) do
#    followers = MediaServer.MediaActions.movie(3) |> MediaServer.MediaActions.followers()

    task =
      Task.Supervisor.async_nolink(MediaServer.TaskSupervisor, fn ->
        Enum.each([], fn x -> x end)
      end)

    Map.put(state, :notify_followers, task.ref)
  end

  def handle_info({ref, :ok}, state) do
    Process.demonitor(ref, [:flush])

    {_value, state} = Map.pop(state, :notify_followers)

    {:noreply, state}
  end

  def handle_info({:DOWN, _ref, :process, _pid, _reason}, state) do
    {:noreply, state}
  end

  def handle_info({:added}, state) do
    MediaServer.MoviesIndex.reset()

    {:noreply, state |> notify_followers}
  end

  def handle_info({:deleted}, state) do
    MediaServer.MoviesIndex.reset()

    {:noreply, state}
  end

  def handle_info({:deleted_file}, state) do
    MediaServer.MoviesIndex.reset()

    {:noreply, state}
  end
end
