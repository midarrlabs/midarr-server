defmodule MediaServerWeb.MoviesLive.Show do
  use MediaServerWeb, :live_view

  import Ecto.Query

  alias MediaServer.Providers.Radarr
  alias MediaServer.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  defp get_movie(socket, movie) do
    provider = Radarr |> last(:inserted_at) |> Repo.one

    case HTTPoison.get("#{ provider.url }/movie/#{ movie }?apiKey=#{ provider.api_key }") do

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        decoded = Jason.decode!(body)

        socket
        |> assign(:page_title, "#{ decoded["title"] } (#{ decoded["year"] })")
        |> assign(:decoded, decoded)
    end
  end

  @impl true
  def handle_params(%{"movie" => movie}, _, socket) do

    {
      :noreply,
      get_movie(socket, movie)
    }
  end

  @impl true
  def handle_event("play", %{"movie" => movie}, socket) do
    {:noreply, push_redirect(socket, to: "/movies/#{ movie }/watch")}
  end
end
