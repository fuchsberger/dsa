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
  def t(:forgot_password?), do: dgettext(@d, "Passwort vergessen?")
  def t(:form_error), do: dgettext(@d, "Oops, etwas ist schief gelaufen! Bitte überprüfe die angeführten Fehler.")
  def t(:or), do: dgettext(@d, "Or")

  # Session controller
  def t(:logged_out), do: dgettext(@d, "Erfolgreich ausgeloggt.")
  def t(:invalid_email_or_password), do: dgettext(@d, "Ungültige Email Addresse oder Passwort.")
  def t(:confirm_before_signin), do: dgettext(@d, "Bitte bestätige noch deine Email Addresse. Ein Aktivierungslink wurde an dich gesendet.")
  def t(:blocked_message), do: dgettext(@d, "Dein Account wurde gesperrt, bitte kontaktierte einen Administrator")

  # Session view / templates
  def t(:heading_sign_in), do: dgettext(@d, "Anmeldung")
  def t(:register_link), do: dgettext(@d, "registriere dich hier")
  def t(:email_address), do: dgettext(@d, "Email Addresse")
  def t(:password), do: dgettext(@d, "Passwort")
  def t(:remember_me), do: dgettext(@d, "Für 60 Tage eingeloggt bleiben")
  def t(:sign_in), do: dgettext(@d, "Einloggen")
  def t(:or_sign_in), do: dgettext(@d, "oder melde dich an")
  def t(:sign_out), do: dgettext(@d, "Ausloggen")


  # Registration controller
  def t(:registration_successful), do: dgettext(@d, "Willkommen im DSA Tool! Bitte bestätige noch deine Email Addresse. Ein Aktivierungslink wurde an dich gesendet.")

  # Registration view / templates
  def t(:heading_registration), do: dgettext(@d, "Registrierung")
  def t(:signin_link), do: dgettext(@d, "melde dich an")
  def t(:username), do: dgettext(@d, "Benutzername")
  def t(:password_confirmation), do: dgettext(@d, "Bestätige Passwort")
  def t(:sign_up), do: dgettext(@d, "Benutzer registrieren")

  # confirmation
  def t(:resend_confirmation), do: dgettext(@d, "Resend confirmation instructions")
  def t(:confirm_account), do: dgettext(@d, "Confirm Account")
  def t(:confirm_success), do: dgettext(@d, "User confirmed successfully.")
  def t(:confirm_invalid), do: dgettext(@d, "User confirmation link is invalid or it has expired.")
  def t(:confirm_message), do: dgettext(@d, "If your email is in our system and it has not been confirmed yet, you will receive an email with instructions shortly.")

  # Reset password controller
  def t(:reset_password), do: dgettext(@d, "Passwort zurücksetzen")
  def t(:reset_password_msg), do: dgettext(@d, "Sollte sich deine Email Addresse in unserem System befinden wirst du in Kürze Anweisungen erhalten um dein Passwort zurückzusetzen.")
  def t(:reset_password_invalid), do: dgettext(@d, "Der Link zum zurücksetzen deines Passworts ist abgelaufen oder ungültig.")
  def t(:reset_password_success), do: dgettext(@d, "Passwort wurde erfolgreich zurückgesetzt.")
  def t(:send_reset_instructions), do: dgettext(@d, "Sende Anweisungen")
  def t(:new_password), do: dgettext(@d, "Neues Passwort")

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
