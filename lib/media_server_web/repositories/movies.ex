defmodule MediaServerWeb.Repositories.Movies do
  def get_url(url) do
    case Application.get_env(:media_server, :movies_base_url) === nil ||
           Application.get_env(:media_server, :movies_api_key) === nil do
      true ->
        :error

      false ->
        "#{Application.get_env(:media_server, :movies_base_url)}/api/v3/#{url}?apiKey=#{Application.get_env(:media_server, :movies_api_key)}"
    end
  end

  def handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    Jason.decode!(body)
  end

  def handle_response(_) do
    []
  end

  def get_all() do
    HTTPoison.get(get_url("movie"))
    |> handle_response()
    |> Enum.filter(fn item -> item["hasFile"] end)
    |> Enum.sort_by(& &1["title"], :asc)
  end

  def get_movie(id) do
    HTTPoison.get(get_url("movie/#{id}"))
    |> handle_response()
  end

  def get_movie_path(id) do
    movie =
      HTTPoison.get("#{get_url("movie/#{id}")}")
      |> handle_response()

    movie["movieFile"]["path"]
  end

  def get_poster(movie) do
    (Stream.filter(movie["images"], fn item -> item["coverType"] === "poster" end)
     |> Enum.at(0))["remoteUrl"]
  end

  def get_background(movie) do
    (Stream.filter(movie["images"], fn item -> item["coverType"] === "fanart" end)
     |> Enum.at(0))["remoteUrl"]
  end

  def get_headshot(movie) do
    (Stream.filter(movie["images"], fn item -> item["coverType"] === "headshot" end)
     |> Enum.at(0))["url"]
  end

  def get_cast(id) do
    HTTPoison.get("#{get_url("credit")}&movieId=#{id}")
    |> handle_response()
    |> Stream.filter(fn item -> item["type"] === "cast" end)
  end

  def search(query) do
    HTTPoison.get("#{get_url("movie/lookup")}&term=#{URI.encode(query)}")
    |> handle_response()
    |> Stream.filter(fn item -> item["hasFile"] end)
    |> Enum.sort_by(& &1["title"], :asc)
  end

  def handle_subtitle(nil, _parent_folder) do
    nil
  end

  def handle_subtitle(subtitle, parent_folder) do
    "#{parent_folder}/#{subtitle}"
  end

  def get_subtitle_path_for(id) do
    movie = get_movie(id)

    MediaServerWeb.Helpers.get_subtitle(movie["folderName"], movie["movieFile"]["relativePath"])
    |> handle_subtitle(movie["folderName"])
  end
end
