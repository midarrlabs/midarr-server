defmodule MediaServerWeb.MoviesLive.Index do
  use MediaServerWeb, :live_view

  import Ecto.Query

  alias MediaServer.Providers.Radarr
  alias MediaServer.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do

    provider = Radarr |> last(:inserted_at) |> Repo.one

    case HTTPoison.get(provider.url<>"/movie?apiKey="<>provider.api_key) do

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        decoded = Jason.decode!(body)

        filtered = Enum.filter(decoded, fn x -> x["hasFile"] end)

        socket
        |> assign(:page_title, :Movies)
        |> assign(:decoded, filtered)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end
end
