defmodule MediaServerWeb.Repositories.Movies do
  alias MediaServer.Token

  def get_url(url) do
    "#{System.get_env("RADARR_BASE_URL")}/api/v3/#{url}?apiKey=#{System.get_env("RADARR_API_KEY")}"
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

  def set_notification() do
    HTTPoison.post(
      get_url("notification"),
      Jason.encode!(%{
        "onGrab" => false,
        "onDownload" => true,
        "onUpgrade" => false,
        "onRename" => false,
        "onMovieDelete" => false,
        "onMovieFileDelete" => false,
        "onMovieFileDeleteForUpgrade" => true,
        "onHealthIssue" => false,
        "onApplicationUpdate" => false,
        "supportsOnGrab" => true,
        "supportsOnDownload" => true,
        "supportsOnUpgrade" => true,
        "supportsOnRename" => true,
        "supportsOnMovieDelete" => true,
        "supportsOnMovieFileDelete" => true,
        "supportsOnMovieFileDeleteForUpgrade" => true,
        "supportsOnHealthIssue" => true,
        "supportsOnApplicationUpdate" => true,
        "includeHealthWarnings" => false,
        "name" => "Midarr",
        "fields" => [
          %{
            "name" => "url",
            "value" =>
              "#{System.get_env("APP_URL")}/api/webhooks/movie?token=#{Token.get_token()}"
          },
          %{
            "name" => "method",
            "value" => 1
          },
          %{
            "name" => "username"
          },
          %{
            "name" => "password"
          }
        ],
        "implementationName" => "Webhook",
        "implementation" => "Webhook",
        "configContract" => "WebhookSettings",
        "infoLink" => "https://wiki.servarr.com/radarr/supported#webhook",
        "tags" => []
      }),
      %{
        "Content-Type" => "application/json"
      }
    )
  end

  def get_notification do
    HTTPoison.get(get_url("notification"))
    |> handle_response()
  end
end
