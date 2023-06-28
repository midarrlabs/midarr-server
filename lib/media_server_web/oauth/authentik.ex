defmodule Authentik do
  @moduledoc """
  An OAuth2 strategy for Authentik.
  """
  use OAuth2.Strategy

  alias OAuth2.Strategy.AuthCode

  defp config do
    [
      strategy: Authentik,
      site: System.get_env("OAUTH_ISSUER_URL"),
      authorize_url: System.get_env("OAUTH_AUTHORIZE_URL"),
      token_url: System.get_env("OAUTH_TOKEN_URL"),
      client_id: System.get_env("OAUTH_CLIENT_ID"),
      client_secret: System.get_env("OAUTH_CLIENT_SECRET"),
      redirect_uri: System.get_env("OAUTH_REDIRECT_URI")
    ]
  end

  def client do
    OAuth2.Client.new(config())
  end

  def authorize_url!(params \\ []) do
    OAuth2.Client.authorize_url!(client())
  end

  def get_token!(params \\ [], headers \\ []) do
    OAuth2.Client.get_token!(client(), params)
  end

  def authorize_url(client, params) do
    AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("Accept", "application/json")
    |> AuthCode.get_token(params, headers)
  end
end