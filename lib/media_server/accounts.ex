defmodule MediaServer.Accounts do

  import Ecto.Query, warn: false
  alias MediaServer.Repo

  alias MediaServer.Accounts.{User, UserToken, UserNotifier}

  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    user = Repo.get_by(User, email: email)
    if User.valid_password?(user, password), do: user
  end

  def get_user!(id), do: Repo.get!(User, id)

  def register_user(attrs) do
    case %User{} |> User.registration_changeset(attrs) |> Repo.insert() do
      {:ok, user} ->

        MediaServer.Accounts.generate_user_api_token(user)

        Phoenix.PubSub.broadcast(MediaServer.PubSub, "user", {:registered, user})

        {:ok, user}

      {:error, error} -> {:error, error}
    end
  end

  def update_user_name(user, attrs) do
    user
    |> User.name_changeset(attrs)
    |> Repo.update()
  end

  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end

  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)

    Repo.one(query) |> MediaServer.Repo.preload(:api_token)
  end

  def delete_session_token(token) do
    Repo.delete_all(UserToken.token_and_context_query(token, "session"))
    :ok
  end

  def generate_user_api_token(user) do
    {token, user_token} = UserToken.build_api_token(user)
    MediaServer.Accounts.UserToken.insert_or_update(user_token)
    token
  end

  def deliver_user_invitation_instructions(%User{} = user, password) do
    user = user |> MediaServer.Repo.preload(:api_token)

    UserNotifier.deliver_invitation_instructions(user, password)
  end
end
