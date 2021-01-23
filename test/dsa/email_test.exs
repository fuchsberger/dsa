# Unit Test
defmodule Dsa.EmailTest do
  use ExUnit.Case

  test "test email" do
    user = %Dsa.Accounts.User{username: "John", email: "person@example.com"}

    email = Dsa.Email.test_email(user)

    assert email.to == user
    assert email.subject == "Test Email"
    assert email.html_body =~ "<strong>HTML</strong> Email Content"
  end
end

# Integration Test
defmodule Dsa.EmailDeliveryTest do
  use ExUnit.Case
  use Bamboo.Test

  test "sends welcome email" do
    user = %Dsa.Accounts.User{username: "John", email: "person@example.com"}
    email = Dsa.Email.test_email(user)

    email |> Dsa.Mailer.deliver_now

    # Works with deliver_now and deliver_later
    assert_delivered_email email
  end
end
