defmodule MediaServerWeb.Repositories.Movies do

  def get_url(url) do
    case Application.get_env(:media_server, :movies_base_url) === nil || Application.get_env(:media_server, :movies_api_key) === nil do
      true ->
        :error

      false ->
        "#{ Application.get_env(:media_server, :movies_base_url) }/api/v3/#{ url }?apiKey=#{ Application.get_env(:media_server, :movies_api_key) }"
    end
  end

  def get_latest(amount) do

    case HTTPoison.get(get_url("movie")) do

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->

        Enum.sort_by(Jason.decode!(body), &(&1["movieFile"]["dateAdded"]), :desc)
        |> Enum.filter(fn x -> x["hasFile"] end)
        |> Enum.take(amount)

      {:error, %HTTPoison.Error{id: nil, reason: :nxdomain}} -> []
    end
  end

  def get_all() do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get(get_url("movie"))

    Enum.filter(Jason.decode!(body), fn x -> x["hasFile"] end)
    |> Enum.sort_by(&(&1["title"]), :asc)
  end

  def get_movie(id) do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get(get_url("movie/#{ id }"))

    Jason.decode!(body)
  end

  def get_movie_path(id) do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get("#{ get_url("movie/#{ id }") }")

    Jason.decode!(body)["movieFile"]["path"]
  end

  def get_poster(movie) do
    (Enum.filter(movie["images"], fn x -> x["coverType"] === "fanart" end) |> Enum.at(0))["remoteUrl"]
  end
end