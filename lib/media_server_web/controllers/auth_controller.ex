defmodule MediaServerWeb.AuthController do
  use MediaServerWeb, :controller

  @doc """
  This action is reached via `/auth/:provider` and redirects to the OAuth2 provider
  based on the chosen strategy.
  """
  def index(conn, %{"provider" => provider}) do
    redirect conn, external: authorize_url!(provider)
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  @doc """
  This action is reached via `/auth/:provider/callback` is the callback URL that
  the OAuth2 provider will redirect the user back to with a `code` that will
  be used to request an access token. The access token will then be used to
  access protected resources on behalf of the user.
  """
  def callback(conn, %{"provider" => provider, "code" => code}) do
    # Exchange an auth code for an access token
    client = get_token!(provider, code)

    # Request the user's data with the access token
    if user = MediaServer.Accounts.get_user_by_email(get_user!(provider, client).email) do

      MediaServerWeb.UserAuth.log_in_user(conn, user)
    end

    conn
    |> redirect(to: "/")
  end

  defp authorize_url!("authentik"), do: Authentik.authorize_url!
  defp authorize_url!(_), do: raise "No matching provider available"

  defp get_token!("authentik", code), do: Authentik.get_token!(code: code)
  defp get_token!(_, _), do: raise "No matching provider available"

  defp get_user!("authentik", client) do

    token = Map.get(client, :token) |> Map.get(:access_token) |> Jason.decode! |> Map.get("access_token")

    %{body: user} = OAuth2.Client.get!(client, System.get_env("OAUTH_USER_URL"), [
      {"authorization", "Bearer #{ token }"}
    ])

    decoded_user =  Jason.decode!(user)

    %{name: decoded_user["name"], email: decoded_user["email"]}
  end
end