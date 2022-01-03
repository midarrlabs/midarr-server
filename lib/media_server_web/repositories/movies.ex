defmodule MediaServerWeb.Repositories.Movies do

  import Ecto.Query
  alias MediaServer.Repo
  alias MediaServer.Providers.Radarr

  def get_url(url) do
    radarr = Radarr |> last(:inserted_at) |> Repo.one

    "#{ radarr.url }/#{ url }?apiKey=#{ radarr.api_key }"
  end

  def get_latest(amount) do

    case HTTPoison.get(get_url("movie")) do

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        decoded = Jason.decode!(body)

        Enum.sort_by(decoded, &(&1["movieFile"]["dateAdded"]), :desc)
        |> Enum.filter(fn x -> x["hasFile"] end)
        |> Enum.take(amount)
    end
  end
end