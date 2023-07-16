defmodule MediaServerWeb.Repositories.Movies do
  def get(url) do
    if String.valid?(System.get_env("RADARR_BASE_URL")) and
         String.valid?(System.get_env("RADARR_API_KEY")) do
      HTTPoison.get("#{System.get_env("RADARR_BASE_URL")}/api/v3/#{url}", %{
        "X-Api-Key" => System.get_env("RADARR_API_KEY")
      })
    else
      nil
    end
  end

  def post(url, body) do
    if String.valid?(System.get_env("RADARR_BASE_URL")) and
         String.valid?(System.get_env("RADARR_API_KEY")) do
      HTTPoison.post("#{System.get_env("RADARR_BASE_URL")}/api/v3/#{url}", body, %{
        "X-Api-Key" => System.get_env("RADARR_API_KEY"),
        "Content-Type" => "application/json"
      })
    else
      nil
    end
  end

  def handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    Jason.decode!(body)
  end

  def handle_response(_) do
    []
  end

  def get_all() do
    get("movie")
    |> handle_response()
    |> Enum.filter(fn item -> item["hasFile"] end)
    |> Enum.sort_by(& &1["title"], :asc)
  end

  def get_cast(id) do
    get("credit?movieId=#{id}")
    |> handle_response()
    |> Stream.filter(fn item -> item["type"] === "cast" end)
  end
end
