defmodule MediaServerWeb.Repositories.Series do

  import Ecto.Query
  alias MediaServer.Repo
  alias MediaServer.Providers.Sonarr

  def get_url(url) do
    sonarr = Sonarr |> last(:inserted_at) |> Repo.one

    "#{ sonarr.url }/#{ url }?apikey=#{ sonarr.api_key }"
  end

  def get_latest(amount) do

    case HTTPoison.get(get_url("series")) do

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        decoded = Jason.decode!(body)

        Enum.sort_by(decoded, &(&1["added"]), :desc)
        |> Enum.filter(fn x -> x["sizeOnDisk"] end)
        |> Enum.take(amount)
    end
  end
end