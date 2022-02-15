defmodule MediaServerWeb.WatchLive.Show do
  use MediaServerWeb, :live_view

  @impl true
  def handle_params(%{"movie" => id}, _, socket) do
    movie = MediaServerWeb.Repositories.Movies.get_movie(id)

    {
      :noreply,
      socket
      |> assign(:poster, (Enum.filter(movie["images"], fn x -> x["coverType"] === "fanart" end) |> Enum.at(0))["remoteUrl"])
      |> assign(:page_title, "#{ movie["title"] }")
      |> assign(:stream_url, "/movies/#{ movie["id"] }/stream")
    }
  end

  @impl true
  def handle_params(%{"episode" => id}, _, socket) do
    episode = MediaServerWeb.Repositories.Series.get_episode(id)

    {
      :noreply,
      socket
      |> assign(:poster, (Enum.filter(episode["series"]["images"], fn x -> x["coverType"] === "fanart" end) |> Enum.at(0))["url"])
      |> assign(:page_title, "#{ episode["series"]["title"] }: #{ episode["title"] }")
      |> assign(:stream_url, "/episodes/#{ episode["id"] }/stream")
    }
  end
end
