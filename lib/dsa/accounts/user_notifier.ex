defmodule Dsa.Mailer do
  use Bamboo.Mailer, otp_app: :dsa
end

defmodule Dsa.Accounts.UserNotifier do
  import Bamboo.Email
  import DsaWeb.Gettext

  @sender {"DSA Tool", "noreply@fuchsberger.us"}

  defimpl Bamboo.Formatter, for: Dsa.Accounts.UserCredential do
    # Used by `to`, `bcc`, `cc` and `from`
    def format_email_address(credential, _opts), do: credential.email
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(credential, url) do
    new_email(
      to: credential,
      from: @sender,
      subject: dgettext("account", "DSA Tool - Account Activation"),
      text_body: dgettext("account", "Greetings,\n\nYou can activate your account by visiting the URL below:\n%{url}\n\nIf you have not created an account with us, please ignore this.\n\nBest,\nThe DSA Team", url: url))
    |> Dsa.Mailer.deliver_now!()
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(credential, url) do
    new_email(
      to: credential,
      from: @sender,
      subject: dgettext("account", "DSA Tool - Reset Password"),
      text_body: dgettext("account", "Greetings,\n\nYou can reset your password by visiting the URL below:\n%{url}\n\nIf you didn't request this change, please ignore this.\n\nBest,\nThe DSA Team", url: url))
    |> Dsa.Mailer.deliver_now!()
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(credential, url) do
    new_email(
      to: credential,
      from: @sender,
      subject: dgettext("account", "DSA Tool - Change Email"),
      text_body: dgettext("account", "Greetings,\n\nYou can change your email by visiting the URL below:\n%{url}\n\nIf you didn't request this change, please ignore this.\n\nBest,\nThe DSA Team", url: url))
    |> Dsa.Mailer.deliver_now!()
  end

  # TODO test actual emails and remove this
  def test_email(user) do
    new_email(
      to: user,
      from: @sender,
      subject: "Test Email",
      html_body: "<strong>HTML</strong> Email Content",
      text_body: "Text Email Content"
    )
  end
end
