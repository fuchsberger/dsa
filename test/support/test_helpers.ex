defmodule Dsa.TestHelpers do

  alias Dsa.{Accounts, Characters}

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

    {confirmed, admin} = if is_map(attrs),
      do: {Map.get(attrs, :confirmed, true), Map.get(attrs, :admin, false)},
      else: {Keyword.get(attrs, :confirmed, true), Keyword.get(attrs, :admin, false)}

    case {confirmed, admin} do
      {true, true} -> Accounts.manage_user!(user, %{confirmed: true, token: nil, admin: true})
      {true, false} -> Accounts.manage_user!(user, %{confirmed: true, token: nil})
      {false, true} -> Accounts.manage_user!(user, %{admin: true})
      _ -> user
    end
  end

  def character_fixture(%Accounts.User{} = user, attrs \\ %{}) do
    attrs = Enum.into(attrs, %{
      name: attrs[:name] || "char_#{System.unique_integer([:positive])}",
      mu: attrs[:mu] || 8, kl: attrs[:kl] || 9, in: attrs[:in] || 10, ch: attrs[:ch] || 11,
      ff: attrs[:ff] || 12, ge: attrs[:ge] || 13, ko: attrs[:ko] || 14, kk: attrs[:kk] || 15,
      le_max: attrs[:le_max] || 30, ae_max: attrs[:ae_max] || 30, ke_max: attrs[:ke_max] || 30,
      sp: attrs[:sp] || 3, zk: attrs[:zk] || 1, sk: attrs[:sk] || 1
    })

    {:ok, character} = Characters.create(user, attrs)
    character
  end

  def unauthorized_response(conn) do
    html_response(conn, 401) =~ "You must authenticate to access the requested response."
  end

  def unconfirmed_response(conn) do
    html_response(conn, 401) =~ "Account must be confirmed first. Please check your email."
  end
end
