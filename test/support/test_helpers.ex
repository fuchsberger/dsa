defmodule Dsa.TestHelpers do

  alias Dsa.Accounts

  import Phoenix.ConnTest, only: [html_response: 2]

  def group_fixture(attrs \\ %{}) do
    {:ok, group} =
      attrs
      |> Enum.into(%{name: (attrs[:name] || "Testgroup")})
      |> Accounts.create_group()

    group
  end

  def user_fixture(attrs \\ %{}) do
    id = System.unique_integer([:positive])

    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: attrs[:email] || "test#{id}@test.abc",
        username: attrs[:username] || "user#{id}",
        password: attrs[:password] || "Supersecret123",
        password_confirm: attrs[:password_confirm] || attrs[:password] || "Supersecret123"
      })
      |> Accounts.register_user()

    user = Accounts.preload_characters(user)

    case {Map.get(attrs, :confirmed, true), Map.get(attrs, :admin, false)} do
      {true, true} -> Accounts.manage_user!(user, %{confirmed: true, token: nil, admin: true})
      {true, false} -> Accounts.manage_user!(user, %{confirmed: true, token: nil})
      {false, true} -> Accounts.manage_user!(user, %{admin: true})
      _ -> user
    end
  end

  def unauthorized_response(conn) do
    html_response(conn, 401) =~ "You must authenticate to access the requested response."
  end

  def unconfirmed_response(conn) do
    html_response(conn, 401) =~ "Account must be confirmed first. Please check your email."
  end
end
