defmodule MediaServer.Accounts.UserToken do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  @session_validity_in_days 60

  schema "users_tokens" do
    field :token, :string
    field :context, :string

    belongs_to :user, MediaServer.Accounts.User

    timestamps(updated_at: false)
  end

  def changeset(user_token, attrs) do
    user_token
    |> cast(attrs, [:token, :context, :user_id])
  end

  @doc """
  Generates a token that will be stored in a signed place,
  such as session or cookie. As they are signed, those
  tokens do not need to be hashed.

  The reason why we store session tokens in the database, even
  though Phoenix already provides a session cookie, is because
  Phoenix' default session cookies are not persisted, they are
  simply signed and potentially encrypted. This means they are
  valid indefinitely, unless you change the signing/encryption
  salt.

  Therefore, storing them allows individual user
  sessions to be expired. The token system can also be extended
  to store additional data, such as the device used for logging in.
  You could then use this information to display all valid sessions
  and devices in the UI and allow users to explicitly expire any
  session they deem invalid.
  """
  def build_session_token(user) do
    token = Ecto.UUID.generate

    {token, %MediaServer.Accounts.UserToken{token: token, context: "session", user_id: user.id}}
  end

  @doc """
  Checks if the token is valid and returns its underlying lookup query.

  The query returns the user found by the token, if any.

  The token is valid if it matches the value in the database and it has
  not expired (after @session_validity_in_days).
  """
  def verify_session_token_query(token) do
    query =
      from token in token_and_context_query(token, "session"),
        join: user in assoc(token, :user),
        where: token.inserted_at > ago(@session_validity_in_days, "day"),
        select: user

    {:ok, query}
  end

  def build_api_token(user) do
    token = Ecto.UUID.generate |> binary_part(16,16)

    {token, %{token: token, context: "api", user_id: user.id}}
  end

  def all do
    MediaServer.Repo.all(__MODULE__)
  end

  def insert_or_update(attrs) do
    case MediaServer.Repo.get_by(__MODULE__, [context: attrs.context, user_id: attrs.user_id]) do
      nil  -> %__MODULE__{
                token: attrs.token,
                context: attrs.context,
                user_id: attrs.user_id
              }
      item -> item
    end
    |> changeset(attrs)
    |> MediaServer.Repo.insert_or_update
  end

  @doc """
  Returns the token struct for the given token value and context.
  """
  def token_and_context_query(token, context) do
    from MediaServer.Accounts.UserToken, where: [token: ^token, context: ^context]
  end

  @doc """
  Gets all tokens for the given user for the given contexts.
  """
  def user_and_contexts_query(user, :all) do
    from t in MediaServer.Accounts.UserToken, where: t.user_id == ^user.id
  end

  def user_and_contexts_query(user, [_ | _] = contexts) do
    from t in MediaServer.Accounts.UserToken,
      where: t.user_id == ^user.id and t.context in ^contexts
  end
end
