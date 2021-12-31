defmodule MediaServerWeb.HomeLive.Index do
  use MediaServerWeb, :live_view

  import Ecto.Query

  alias MediaServer.Providers.Radarr
  alias MediaServer.Providers.Sonarr
  alias MediaServer.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp get_latest_movies(socket) do
    radarr = Radarr |> last(:inserted_at) |> Repo.one

    case HTTPoison.get(radarr.url<>"/movie?apiKey="<>radarr.api_key) do

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        decoded = Jason.decode!(body)

        movies =  Enum.sort_by(decoded, &(&1["movieFile"]["dateAdded"]), :desc)
                  |> Enum.filter(fn x -> x["hasFile"] end)
                  |> Enum.take(6)

        socket
        |> assign(:latest_movies, movies)
    end
  end

  defp get_latest_series(socket) do
    sonarr = Sonarr |> last(:inserted_at) |> Repo.one

    case HTTPoison.get("#{ sonarr.url }/series?apikey=#{ sonarr.api_key }") do

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        decoded = Jason.decode!(body)

        series =  Enum.sort_by(decoded, &(&1["added"]), :desc)
                  |> Enum.filter(fn x -> x["sizeOnDisk"] end)
                  |> Enum.take(6)

        socket
        |> assign(:latest_series, series)
    end
  end

  defp apply_action(socket, :index, _params) do
    get_latest_movies(get_latest_series(socket))
  end
end
