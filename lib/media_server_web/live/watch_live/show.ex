defmodule MediaServerWeb.WatchLive.Show do
  use Phoenix.LiveView, layout: {MediaServerWeb.WatchView, "watch.html"}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"movie" => movie}, _, socket) do
    decoded = MediaServerWeb.Repositories.Movies.get_movie(movie)

    {
      :noreply,
      socket
      |> assign(:poster, (Enum.filter(decoded["images"], fn x -> x["coverType"] === "fanart" end) |> Enum.at(0))["remoteUrl"])
      |> assign(:page_title, "#{ decoded["title"] }")
      |> assign(:stream_url, "/movies/#{ decoded["id"] }/stream")
    }
  end

  @impl true
  def handle_params(%{"episode" => episode}, _, socket) do
    decoded = MediaServerWeb.Repositories.Series.get_episode(episode)

    {
      :noreply,
      socket
      |> assign(:poster, (Enum.filter(decoded["series"]["images"], fn x -> x["coverType"] === "fanart" end) |> Enum.at(0))["url"])
      |> assign(:page_title, "#{ decoded["series"]["title"] }: #{ decoded["title"] }")
      |> assign(:stream_url, "/episodes/#{ decoded["id"] }/stream")
    }
  end
end
