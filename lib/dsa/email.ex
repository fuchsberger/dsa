defmodule Dsa.Email do
  import Bamboo.Email

  def welcome_email do
    new_email(
      to: "alex.fuchsberger@gmail.com",
      from: "admin@fuchsberger.us",
      subject: "Welcome to the app.",
      html_body: "<strong>Thanks for joining!</strong>",
      text_body: "Thanks for joining!"
    )
  end
end

defmodule Dsa.Mailer do
  use Bamboo.Mailer, otp_app: :dsa
end
