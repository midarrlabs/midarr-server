defmodule MediaServerWeb.OAuthController do
  use MediaServerWeb, :controller

  def index(conn, _params) do
    redirect conn, external: MediaServerWeb.OAuth.authorize_url!
  end

  def callback(conn, %{"code" => code}) do
    client = MediaServerWeb.OAuth.get_token!(code: code)

    if user = MediaServer.Accounts.get_user_by_email(MediaServerWeb.OAuth.get_user!(client).email) do

      MediaServerWeb.UserAuth.log_in_user(conn, user)
    end

    conn
    |> redirect(to: "/")
  end
end