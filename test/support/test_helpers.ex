defmodule Dsa.TestHelpers do

  alias Dsa.Accounts

  def user_fixtures(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "test@test.abc",
        username: "user#{System.unique_integer([:positive])}",
        password: attrs[:password] || "Supersecret123",
        password_confirm: attrs[:password_confirm] || "Supersecret123"
      })
      |> Accounts.register_user()

    user
  end
end
