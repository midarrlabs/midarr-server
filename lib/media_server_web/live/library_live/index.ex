defmodule MediaServerWeb.LibraryLive.Index do
  use MediaServerWeb, :live_view

  alias MediaServer.Media
  alias MediaServer.Media.Library

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :libraries, list_libraries())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Library")
    |> assign(:library, Media.get_library!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Library")
    |> assign(:library, %Library{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Libraries")
    |> assign(:library, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    library = Media.get_library!(id)
    {:ok, _} = Media.delete_library(library)

    {:noreply, assign(socket, :libraries, list_libraries())}
  end

  @impl true
  def handle_event("scan", %{}, socket) do
        files = Media.list_files()

        task = Task.async(fn -> 
            Enum.each(files, fn file ->

                if file.poster === nil do
                    case HTTPoison.get("https://api.themoviedb.org/3/search/multi?api_key=17b1975a6335a9db0fedd3abaa0ea701&language=en-US&query=#{URI.encode(file.title)}&page=1&include_adult=false") do

                    {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
                        decoded = Jason.decode!(body)

                        poster_path = List.first(Enum.map(decoded["results"], &(Map.get(&1, "poster_path"))))

                        if poster_path !== nil do
                            Media.update_file(file, %{poster: poster_path})

                            %HTTPoison.Response{body: data} = HTTPoison.get!("https://image.tmdb.org/t/p/original#{poster_path}")

                            File.write!("/app/priv/static/images"<>poster_path, data)
                        end

                    {:ok, %HTTPoison.Response{status_code: 404}} ->
                        IO.puts "Not found :("

                    {:error, %HTTPoison.Error{reason: reason}} ->
                        IO.inspect reason
                    end
                end
            end)
        end)

        Task.await(task, :infinity)

    {:noreply, socket}
  end

  defp list_libraries do
    Media.list_libraries()
  end
end
