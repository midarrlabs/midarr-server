defmodule MediaServerWeb.Repositories.Series do
  def get(url) do
    HTTPoison.get("#{System.get_env("SONARR_BASE_URL")}/api/v3/#{url}", %{
      "X-Api-Key" => System.get_env("SONARR_API_KEY")
    })
    |> handle_response()
  end

  def handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    case Jason.decode(body) do
      {:ok, decoded} ->
        decoded
      _ ->
        body
    end
  end

  def handle_response(_) do
    []
  end

  def get_all() do
    get("series?includeSeasonImages=true")
  end
end
