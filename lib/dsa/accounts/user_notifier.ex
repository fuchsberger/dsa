defmodule Dsa.Mailer do
  use Bamboo.Mailer, otp_app: :dsa
end

defmodule Dsa.Accounts.UserNotifier do
  import Bamboo.Email
  import DsaWeb.Gettext

  @sender {"DSA Tool", "noreply@fuchsberger.us"}

  defimpl Bamboo.Formatter, for: Dsa.Accounts.User do
    # Used by `to`, `bcc`, `cc` and `from`
    def format_email_address(user, _opts) do
      {user.username, user.email}
    end
  end

  defp deliver(email) do
    %Bamboo.Email{to: to, text_body: body} =
      email
      |> from({"DSA Tool", "noreply@fuchsberger.us"})
      |> Dsa.Mailer.deliver_now!()

    {:ok, %{to: to, body: body}}
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    new_email(
      to: user,
      subject: dgettext("account", "DSA Tool - Account Activation"),
      text_body: dgettext("account", "Hi %{username},\n\nYou can activate your account by visiting the URL below:\n%{url}\n\nIf you have not created an account with us, please ignore this.\n\nBest,\nThe DSA Team", username: user.username, url: url))
    |> deliver()
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    new_email(
      to: user,
      subject: dgettext("account", "DSA Tool - Reset Password"),
      text_body: dgettext("account", "Hi %{username},\n\nYou can reset your password by visiting the URL below:\n%{url}\n\nIf you didn't request this change, please ignore this.\n\nBest,\nThe DSA Team", username: user.username, url: url))
    |> deliver()
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    new_email(
      to: user,
      subject: dgettext("account", "DSA Tool - Change Email"),
      text_body: dgettext("account", "Hi %{username},\n\nYou can change your email by visiting the URL below:\n%{url}\n\nIf you didn't request this change, please ignore this.\n\nBest,\nThe DSA Team", username: user.username, url: url))
    |> deliver()
  end
end
