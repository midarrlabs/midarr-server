defmodule MediaServerWeb.MoviesLive.Index do
  use MediaServerWeb, :live_view

  alias Phoenix.LiveView.JS

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(:page_title, "Movies")
    }
  end

  @impl true
  def handle_params(%{"page" => page, "genre" => genre}, _url, socket) do
    {
      :noreply,
      socket
      |> assign(
           :movies,
           Scrivener.paginate(MediaServer.MoviesIndex.get_genre(genre), %{
             "page" => page,
             "page_size" => "50"
           })
         )
    }
  end

  def handle_params(%{"page" => page}, _url, socket) do
    {
      :noreply,
      socket
      |> assign(
        :movies,
        Scrivener.paginate(MediaServer.MoviesIndex.get_all(), %{
          "page" => page,
          "page_size" => "50"
        })
      )
    }
  end

  def handle_params(%{"genre" => genre}, _url, socket) do

    capitalized_genre = String.capitalize(genre)

    {
      :noreply,
      socket
      |> assign(:page_title, "Movies - #{ capitalized_genre }")
      |> assign(
           :movies,
           Scrivener.paginate(MediaServer.MoviesIndex.get_genre(capitalized_genre), %{
             "page" => "1",
             "page_size" => "50"
           })
         )
    }
  end

  def handle_params(%{"sort_by" => "latest"}, _url, socket) do

    {
      :noreply,
      socket
      |> assign(:page_title, "Movies - Latest")
      |> assign(
           :movies,
           Scrivener.paginate(MediaServer.MoviesIndex.get_latest(), %{
             "page" => "1",
             "page_size" => "50"
           })
         )
    }
  end

  def handle_params(_params, _url, socket) do
    {
      :noreply,
      socket
      |> assign(
        :movies,
        Scrivener.paginate(MediaServer.MoviesIndex.get_all(), %{
          "page" => "1",
          "page_size" => "50"
        })
      )
    }
  end
end
