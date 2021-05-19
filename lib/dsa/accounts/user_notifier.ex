defmodule Dsa.Accounts.UserNotifier do
  import Bamboo.Email
  import DsaWeb.Gettext
  import DsaWeb.AccountTranslations

  alias Dsa.Mailer

  @from {"DSA Tool", "noreply@fuchsberger.us"}

  defimpl Bamboo.Formatter, for: Dsa.Accounts.User do
    # Used by `to`, `bcc`, `cc` and `from`
    def format_email_address(user, _opts) do
      {user.username, user.email}
    end
  end

  defp deliver(to, subject, text_body, html_body) do
    email =
      new_email(
        to: to,
        from: @from,
        subject: subject,
        text_body: text_body,
        html_body: html_body
      )
      |> Mailer.deliver_now()

    {:ok, email}
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    text_body = t(:confirmation_email_text, url, user.username)
    html_body = t(:confirmation_email_html, url, user.username)
    deliver(user, t(:email_subject), text_body, html_body)
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    text_body = t(:reset_password_email_text, url, user.username)
    html_body = t(:reset_password_email_html, url, user.username)
    deliver(user, t(:email_subject), text_body, html_body)
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    text_body = t(:update_email_text, url, user.username)
    html_body = t(:update_email_html, url, user.username)
    deliver(user, t(:email_subject), text_body, html_body)
  end
end
