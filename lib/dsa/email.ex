defmodule Dsa.Mailer do
  use Bamboo.Mailer, otp_app: :dsa
end

defmodule Dsa.Email do
  use Phoenix.Template, root: "templates"

  import Bamboo.Email
  import Phoenix.View, only: [render_to_string: 3]

  alias DsaWeb.EmailView
  require Logger

  @sender %Dsa.Accounts.User{email: "noreply@fuchsberger.us", username: "DSA Tool"}

  defimpl Bamboo.Formatter, for: Dsa.Accounts.User do
    # Used by `to`, `bcc`, `cc` and `from`
    def format_email_address(user, _opts) do
      {user.username, user.email}
    end
  end

  defp url do
    if Mix.env() == :dev, do: "http://localhost:4000", else: "https://dsa.fuchsberger.us"
  end

  def test_email(user) do
    new_email(
      to: user,
      from: @sender,
      subject: "Test Email",
      html_body: "<strong>HTML</strong> Email Content",
      text_body: "Text Email Content"
    )
  end

  def confirmation_email(user) do
    new_email(
      to: user,
      from: @sender,
      subject: "DSA Tool - Account Aktivierung",
      html_body: render_to_string(EmailView, "confirm.html", user: user, url: url()),
      text_body: "Hey #{user.username},\n\nWillkommen im DSA Tool! Um deine Registrierung abzuschließen öffne bitte den folgenden Link:\n#{url()}/confirm/#{user.token}"
    )
  end
end
