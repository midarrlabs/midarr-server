defmodule MediaServer.Webhooks.Movie do
  use Agent

  alias MediaServer.Token
  alias MediaServerWeb.Repositories.Movies

  def start_link(_opts) do
    Agent.start_link(
      fn ->
        Movies.set_notification(%{
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
        })
      end,
      name: __MODULE__
    )
  end
end
