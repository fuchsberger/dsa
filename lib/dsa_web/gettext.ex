defmodule DsaWeb.Gettext do
  @moduledoc """
  A module providing Internationalization with a gettext-based API.

  By using [Gettext](https://hexdocs.pm/gettext),
  your module gains a set of macros for translations, for example:

      import DsaWeb.Gettext

      # Simple translation
      gettext("Here is the string to translate")

      # Plural translation
      ngettext("Here is the string to translate",
               "Here are the strings to translate",
               3)

      # Domain-based translation
      dgettext("errors", "Here is the error message to translate")

  See the [Gettext Docs](https://hexdocs.pm/gettext) for detailed usage.
  """
  use Gettext, otp_app: :dsa, default_domain: "dsa"
end

defmodule DsaWeb.AccountTranslations do
  import DsaWeb.Gettext

  # Set domain for translations
  @d "account"

  # Session Controller
  def t(:logged_out), do: dgettext(@d, "Logged out successfully.")
  def t(:invalid_email_or_password), do: dgettext("account", "Invalid email or password")

  # Session View / Templates
  def t(:heading_sign_in), do: dgettext(@d, "Sign in to your account")
  def t(:or), do: dgettext(@d, "Or")
  def t(:register_link), do: dgettext(@d, "register a new account")
  def t(:email_address), do: dgettext(@d, "Email address")
  def t(:password), do: dgettext(@d, "Password")
  def t(:remember_me), do: dgettext(@d, "Remember me for 60 days")
  def t(:forgot_password?), do: dgettext(@d, "Forgot your password?")
  def t(:sign_in), do: dgettext(@d, "Sign in")
end
