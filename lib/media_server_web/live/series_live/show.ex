defmodule MediaServerWeb.SeriesLive.Show do
  use MediaServerWeb, :live_view

  import Ecto.Query

  alias MediaServer.Providers.Sonarr
  alias MediaServer.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"serie" => serie}, _, socket) do

    show = Sonarr |> last(:inserted_at) |> Repo.one

    case HTTPoison.get("#{ show.url }/series/#{ serie }?apikey=#{ show.api_key }") do

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        decoded = Jason.decode!(body)

        case HTTPoison.get("#{ show.url }/episode?seriesId=#{ serie }&apikey=#{ show.api_key }") do

          {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
            episodes = Jason.decode!(body)

            filtered = Enum.filter(episodes, fn x -> x["hasFile"] end)

            {
              :noreply,
              socket
              |> assign(:page_title, "#{ decoded["title"] } (#{ decoded["year"] })")
              |> assign(:decoded, decoded) |> assign(:episodes, filtered)}
        end
    end
  end

  @impl true
  def handle_event("play", %{"episode" => episode}, socket) do
    {:noreply, push_redirect(socket, to: "/episodes/#{ episode }/watch")}
  end
end
