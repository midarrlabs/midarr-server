defmodule MediaServerWeb.Repositories.Movies do

  def get_url(url) do
    "#{ Application.fetch_env!(:media_server, :movies_base_url) }/api/v3/#{ url }?apiKey=#{ Application.fetch_env!(:media_server, :movies_api_key) }"
  end

  def get_latest(amount) do

    case HTTPoison.get(get_url("movie")) do

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->

        Enum.sort_by(Jason.decode!(body), &(&1["movieFile"]["dateAdded"]), :desc)
        |> Enum.filter(fn x -> x["hasFile"] end)
        |> Enum.take(amount)
    end
  end

  def get_all() do

    case HTTPoison.get(get_url("movie")) do

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->

        Enum.filter(Jason.decode!(body), fn x -> x["hasFile"] end)
        |> Enum.sort_by(&(&1["title"]), :asc)
    end
  end

  def get_movie(id) do

    case HTTPoison.get(get_url("movie/#{ id }")) do

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Jason.decode!(body)
    end
  end

  def get_movie_path(id) do

    case HTTPoison.get("#{ get_url("movie/#{ id }") }") do

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Jason.decode!(body)["movieFile"]["path"]
    end
  end
end