defmodule MediaServerWeb.WatchLive.Show do
  use MediaServerWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:is_watching, true)}
  end

  @impl true
  def handle_params(%{"movie" => movie}, _, socket) do
    decoded = MediaServerWeb.Repositories.Movies.get_movie(movie)

    {
      :noreply,
      socket
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
      |> assign(:page_title, "#{ decoded["title"] }")
      |> assign(:stream_url, "/episodes/#{ decoded["id"] }/stream")
    }
  end
end
