# Unit Test
defmodule Dsa.Accounts.UserNotifierTest do
  use ExUnit.Case
  import DsaWeb.Gettext

  describe "email" do
    @credential %Dsa.Accounts.UserCredential{email: "person@example.com"}
    @sender {"DSA Tool", "noreply@fuchsberger.us"}
    @url "test@test.com"

    test "confirmation" do
      email = Dsa.Accounts.UserNotifier.deliver_confirmation_instructions(@credential, @url)

      assert email.to == ["person@example.com"]
      assert email.from == @sender
      assert email.subject == dgettext("account", "DSA Tool - Account Activation")
      assert email.html_body == nil
      assert email.text_body =~ @url
    end

    test "password reset" do
      email = Dsa.Accounts.UserNotifier.deliver_reset_password_instructions(@credential, @url)

      assert email.to == ["person@example.com"]
      assert email.from == @sender
      assert email.subject == dgettext("account", "DSA Tool - Reset Password")
      assert email.html_body == nil
      assert email.text_body =~ @url
    end

    test "change email" do
      email = Dsa.Accounts.UserNotifier.deliver_update_email_instructions(@credential, @url)

      assert email.to == ["person@example.com"]
      assert email.from == @sender
      assert email.subject == dgettext("account", "DSA Tool - Change Email")
      assert email.html_body == nil
      assert email.text_body =~ @url
    end
  end
end

# Integration Test
# Only need to test one type of email; if it works, will work for all.
defmodule Dsa.EmailDeliveryTest do
  use ExUnit.Case
  use Bamboo.Test

  test "sends confirmation email" do
    credential = %Dsa.Accounts.UserCredential{email: "person@example.com"}
    url = "test@test.com"
    email = Dsa.Accounts.UserNotifier.deliver_confirmation_instructions(credential, url)

    email |> Dsa.Mailer.deliver_now

    # Works with deliver_now and deliver_later
    assert_delivered_email email
  end
end
