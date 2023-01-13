defmodule MediaServerWeb.Repositories.Series do
  def get_url(url) do
    "#{System.get_env("SONARR_BASE_URL")}/api/v3/#{url}?apikey=#{System.get_env("SONARR_API_KEY")}"
  end

  def handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    Jason.decode!(body)
  end

  def handle_response(_) do
    []
  end

  def get_all() do
    HTTPoison.get(get_url("series"))
    |> handle_response()
    |> Enum.filter(fn item -> item["statistics"]["episodeFileCount"] !== 0 end)
    |> Enum.sort_by(& &1["title"], :asc)
  end

  def search(query) do
    HTTPoison.get("#{get_url("series/lookup")}&term=#{URI.encode(query)}")
    |> handle_response()
    |> Enum.filter(fn item -> item["seasonFolder"] end)
    |> Enum.filter(fn item -> item["statistics"]["episodeFileCount"] !== 0 end)
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
        "onSeriesDelete" => false,
        "onEpisodeFileDelete" => false,
        "onEpisodeFileDeleteForUpgrade" => false,
        "onHealthIssue" => false,
        "onApplicationUpdate" => false,
        "supportsOnGrab" => true,
        "supportsOnDownload" => true,
        "supportsOnUpgrade" => true,
        "supportsOnRename" => true,
        "supportsOnSeriesDelete" => true,
        "supportsOnEpisodeFileDelete" => true,
        "supportsOnEpisodeFileDeleteForUpgrade" => true,
        "supportsOnHealthIssue" => true,
        "supportsOnApplicationUpdate" => true,
        "includeHealthWarnings" => false,
        "name" => "Midarr",
        "fields" => [
          %{
            "name" => "url",
            "value" =>
              "#{System.get_env("APP_URL")}/api/webhooks/series?token=#{MediaServer.Token.get_token()}"
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
        "infoLink" => "https://wiki.servarr.com/sonarr/supported#webhook",
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
