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
end
