defmodule MediaServer.Accounts.UserNotifier do
  import Swoosh.Email

  alias MediaServer.Mailer

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from(
        {System.get_env("APP_NAME", "Midarr"),
         System.get_env("APP_MAILER_FROM", "example@email.com")}
      )
      |> subject(subject)
      |> html_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    deliver(user.email, "Confirmation instructions", """

    ==============================

    Hi #{user.email},

    You can confirm your account by visiting the URL below:

    #{url}

    If you didn't create an account with us, please ignore this.

    ==============================
    """)
  end

  def deliver_invitation_instructions(user, password) do
    deliver(user.email, "Invitation instructions", """

    <p>Hi #{user.name}</p>

    <p>An account has been created for you at:</p>

    <a href="#{System.get_env("APP_URL", "")}">#{System.get_env("APP_URL", "")}</a>

    <p>Your account details are:</p>

    <ul>
      <li>Email: #{user.email}</li>
      <li>Password: #{password}</li>
    </ul>

    Your API token is: <strong>#{ user.api_token.token }</strong>
    <br>You can regenerate tokens on your Settings page.

    <p>If you weren't expecting an account with us, please ignore this.</p>
    """)
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    deliver(user.email, "Reset password instructions", """

    ==============================

    Hi #{user.email},

    You can reset your password by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    deliver(user.email, "Update email instructions", """

    ==============================

    Hi #{user.email},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end
end
