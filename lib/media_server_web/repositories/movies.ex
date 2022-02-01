defmodule MediaServerWeb.Repositories.Movies do

  import Ecto.Query
  alias MediaServer.Repo
  alias MediaServer.Integrations.Radarr

  def get_url(url) do
    radarr = Radarr |> last(:inserted_at) |> Repo.one

    case radarr do

      nil ->
        nil

      _ ->
        "#{ radarr.url }/#{ url }?apiKey=#{ radarr.api_key }"
    end
  end

  def get_latest(amount) do

    case get_url("movie") do

      nil -> []

      _ ->
        case HTTPoison.get(get_url("movie")) do

          {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->

            Enum.sort_by(Jason.decode!(body), &(&1["movieFile"]["dateAdded"]), :desc)
            |> Enum.filter(fn x -> x["hasFile"] end)
            |> Enum.take(amount)
        end
    end
  end

  def get_all() do

    case HTTPoison.get(get_url("movie")) do

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        decoded = Jason.decode!(body)

        Enum.filter(decoded, fn x -> x["hasFile"] end)
        |> Enum.sort_by(&(&1["title"]), :asc)
    end
  end

  def get_movie(id) do

    case HTTPoison.get("#{ get_url("movie/#{ id }") }") do

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Jason.decode!(body)
    end
  end

  def get_movie_path(id) do

    case HTTPoison.get("#{ get_url("movie/#{ id }") }") do

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        decoded = Jason.decode!(body)

        decoded["movieFile"]["path"]
    end
  end
end