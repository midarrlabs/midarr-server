defmodule MediaServerWeb.IdentifyLive.Show do
  use MediaServerWeb, :live_view

  alias MediaServer.Media

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    file = Media.get_file!(id)

    case HTTPoison.get("https://api.themoviedb.org/3/search/multi?api_key=17b1975a6335a9db0fedd3abaa0ea701&language=en-US&query=#{URI.encode(file.title)}&page=1&include_adult=false") do

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          decoded = Jason.decode!(body)

          IO.inspect decoded["results"]

              {
                :noreply,
                socket
                |> assign(:page_title, "#{file.title} (#{file.year})")
                |> assign(:results, decoded["results"])
                |> assign(:file, file)
              }

      {:ok, %HTTPoison.Response{status_code: 404}} ->
          IO.puts "Not found :("

      {:error, %HTTPoison.Error{reason: reason}} ->
          IO.inspect reason
    end
  end

  @impl true
  def handle_event("update", %{"id" => id, "title" => title, "poster" => poster_path}, socket) do
    file = Media.get_file!(id)
    Media.update_file(file, %{title: title, poster: poster_path})

    %HTTPoison.Response{body: data} = HTTPoison.get!("https://image.tmdb.org/t/p/original#{poster_path}")

    File.write!("/app/priv/static/images"<>poster_path, data)

    {:noreply, push_redirect(socket, to: "/files/#{id}")}
  end
end
