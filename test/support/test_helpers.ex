defmodule Dsa.TestHelpers do

  alias Dsa.Accounts

  import Phoenix.ConnTest, only: [html_response: 2]

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "test@test.abc",
        username: "user#{System.unique_integer([:positive])}",
        password: attrs[:password] || "Supersecret123",
        password_confirm: attrs[:password_confirm] || attrs[:password] || "Supersecret123"
      })
      |> Accounts.register_user()

    # use a confirmed user for test cases by default
    confirmed = Map.get(attrs, :confirmed, true)

    case confirmed do
      true -> Accounts.manage_user!(user, %{confirmed: true, token: nil})
      false -> user
    end
  end

  def unauthorized_response(conn) do
    html_response(conn, 401) =~ "You must authenticate to access the requested response."
  end

  def unconfirmed_response(conn) do
    html_response(conn, 401) =~ "Account must be confirmed first. Please check your email."
  end
end
