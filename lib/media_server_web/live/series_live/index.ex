defmodule MediaServerWeb.SeriesLive.Index do
  use MediaServerWeb, :live_view

  import Ecto.Query

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

  defp apply_action(socket, :index, _params) do

    provider = Sonarr |> last(:inserted_at) |> Repo.one

    case HTTPoison.get(provider.url<>"/series?apikey="<>provider.api_key) do

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        decoded = Jason.decode!(body)

        socket
        |> assign(:page_title, :Series)
        |> assign(:decoded, decoded)
    end
  end
end
