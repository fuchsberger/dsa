defmodule DsaWeb.AccountTranslations do
  import DsaWeb.Gettext

  # Set domain for translations
  @d "account"

  # Flash messages
  def t(:requires_login), do: dgettext(@d, "Du musst dich anmelden um auf diese Seite zugreifen zu können.")
  def t(:requires_admin), do: dgettext(@d, "Du musst ein Administrator sein, um auf diese Seite zugreifen zu können.")

  # Form errors
  def t(:confirmation_error), do: dgettext(@d, "stimmt nicht mit Passwort überein")
  def t(:email_error), do: dgettext(@d, "muss ein @ symbol und darf keine Leerzeichen enthalten")
  def t(:unchanged_error), do: dgettext(@d, "ist unverändert")
  def t(:invalid_error), do: dgettext(@d, "ist ungültig")

  # General
  def t(:forgot_password?), do: dgettext(@d, "Forgot your password?")
  def t(:form_error), do: dgettext(@d, "Oops, something went wrong! Please check the errors below.")
  def t(:or), do: dgettext(@d, "Or")

  # Session controller
  def t(:logged_out), do: dgettext(@d, "Logged out successfully.")
  def t(:invalid_email_or_password), do: dgettext(@d, "Invalid email or password.")
  def t(:confirm_before_signin), do: dgettext(@d, "Please confirm your email before signing in. An email confirmation link has been sent to you.")
  def t(:blocked_message), do: dgettext(@d, "Your account has been locked, please contact an administrator.")

  # Session view / templates
  def t(:heading_sign_in), do: dgettext(@d, "Sign in to your account")
  def t(:register_link), do: dgettext(@d, "register a new account")
  def t(:email_address), do: dgettext(@d, "Email address")
  def t(:password), do: dgettext(@d, "Password")
  def t(:remember_me), do: dgettext(@d, "Remember me for 60 days")
  def t(:sign_in), do: dgettext(@d, "Sign in")
  def t(:or_sign_in), do: dgettext(@d, "or sign in")
  def t(:sign_out), do: dgettext(@d, "Sign out")


  # Registration controller
  def t(:registration_successful), do: dgettext(@d, "Welcome to DSA Tool! Please confirm your email before signing in. An email confirmation link has been sent to you.")

  # Registration view / templates
  def t(:heading_registration), do: dgettext(@d, "Register Account")
  def t(:signin_link), do: dgettext(@d, "sign into your account")
  def t(:username), do: dgettext(@d, "Username")
  def t(:password_confirmation), do: dgettext(@d, "Confirm Password")
  def t(:sign_up), do: dgettext(@d, "Sign up")

  # confirmation
  def t(:resend_confirmation), do: dgettext(@d, "Resend confirmation instructions")
  def t(:confirm_account), do: dgettext(@d, "Confirm Account")
  def t(:confirm_success), do: dgettext(@d, "User confirmed successfully.")
  def t(:confirm_invalid), do: dgettext(@d, "User confirmation link is invalid or it has expired.")
  def t(:confirm_message), do: dgettext(@d, "If your email is in our system and it has not been confirmed yet, you will receive an email with instructions shortly.")

  # Reset password controller
  def t(:reset_password_msg), do: dgettext(@d, "If your email is in our system, you will receive instructions to reset your password shortly.")
  def t(:reset_password_invalid), do: dgettext(@d, "Reset password link is invalid or it has expired.")
  def t(:reset_password_success), do: dgettext(@d, "Password reset successfully.")

  # Registration view / templates
  def t(:send_reset_instructions), do: dgettext(@d, "Send instructions to reset password")
  def t(:reset_password), do: dgettext(@d, "Reset password")
  def t(:new_password), do: dgettext(@d, "New Password")

  # Settings
  def t(:settings), do: dgettext(@d, "Settings")
  def t(:delete_account_link), do: dgettext(@d, "Delete Account")
  def t(:delete_account_confirmation), do: dgettext(@d, "Are you sure you want to delete your account including all characters?")
  def t(:change_email), do: dgettext(@d, "Change Email")
  def t(:change_password), do: dgettext(@d, "Change Password")
  def t(:current_password), do: dgettext(@d, "Current Password")
  def t(:email_change_sent), do: dgettext(@d, "A link to confirm your email change has been sent to the new address.")
  def t(:update_password_success), do: dgettext(@d, "Password updated successfully.")
  def t(:update_email_success), do: dgettext(@d, "Email changed successfully.")
  def t(:invalid_email_link), do: dgettext(@d, "Email change link is invalid or it has expired.")

  # Emails
  def t(:email_subject), do: dgettext(@d, "DSA Tool - Please Confirm Account")

  def t(:confirmation_email_text, url, username), do: dgettext(@d, "Hi %{username},\n\nYou can confirm your account by visiting the URL below:\n%{url}\n\nIf you have not created an account with us, please ignore this.\n\nBest,\nThe DSA Team", url: url, username: username)
  def t(:confirmation_email_html, url, username), do: dgettext(@d, "Hi %{username},<br/><br/>You can confirm your account by visiting the URL below:<br/><a href=\"%{url}\" target=\"_blank\">%{url}</a><br/><br/>If you have not created an account with us, please ignore this.<br/><br/>Best,<br/>The DSA Team", url: url, username: username)

  def t(:reset_password_email_text, url, username), do: dgettext(@d, "Hi %{username},\n\nYou can reset your password by visiting the url below:\n%{url}\n\nIf you didn't request this change, please ignore this.\n\nBest,\nThe DSA Team", url: url, username: username)
  def t(:reset_password_email_html, url, username), do: dgettext(@d, "Hi %{username},<br/><br/>You can reset your password by visiting the url below:<br/><a href=\"%{url}\" target=\"_blank\">%{url}</a><br/><br/>If you didn't request this change, please ignore this.<br/><br/>Best,<br/>The DSA Team", url: url, username: username)

  def t(:update_email_text, url, username), do: dgettext(@d, "Hi %{username},\n\nYou can change your e-mail by visiting the url below:\n%{url}\n\nIf you didn't request this change, please ignore this.\n\nBest,\nThe DSA Team", url: url, username: username)
  def t(:update_email_html, url, username), do: dgettext(@d, "Hi %{username},<br/><br/>You can change your e-mail by visiting the url below:<br/><a href=\"%{url}\" target=\"_blank\">%{url}</a><br/><br/>If you didn't request this change, please ignore this.<br/><br/>Best,<br/>The DSA Team", url: url, username: username)
end
