defmodule MediaServerWeb.OAuth do
  use OAuth2.Strategy

  alias OAuth2.Strategy.AuthCode

  defp config do
    [
      strategy: __MODULE__,
      client_id: System.get_env("OAUTH_CLIENT_ID"),
      client_secret: System.get_env("OAUTH_CLIENT_SECRET"),
      site: System.get_env("OAUTH_ISSUER_URL"),
      authorize_url: System.get_env("OAUTH_AUTHORIZE_URL"),
      token_url: System.get_env("OAUTH_TOKEN_URL"),
      redirect_uri: System.get_env("OAUTH_REDIRECT_URI")
    ]
  end

  def client do
    OAuth2.Client.new(config())
  end

  def authorize_url!(_params \\ []) do
    OAuth2.Client.authorize_url!(client())
  end

  def authorize_url(client, params) do
    AuthCode.authorize_url(client, params)
  end

  def get_token!(params \\ [], _headers \\ []) do
    OAuth2.Client.get_token!(client(), params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("Accept", "application/json")
    |> AuthCode.get_token(params, headers)
  end

  def get_user!(client) do
    token =
      Map.get(client, :token)
      |> Map.get(:access_token)
      |> Jason.decode!()
      |> Map.get("access_token")

    %{body: user} =
      OAuth2.Client.get!(client, System.get_env("OAUTH_USER_URL"), [
        {"authorization", "Bearer #{token}"}
      ])

    decoded_user = Jason.decode!(user)

    %{name: decoded_user["name"], email: decoded_user["email"]}
  end
end
