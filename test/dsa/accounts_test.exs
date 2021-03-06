defmodule Dsa.AccountsTest do
  use Dsa.DataCase, async: true

  alias Dsa.Accounts
  alias Dsa.Accounts.User

  describe "register_user/1" do
    @valid_attrs %{
      email: "test@test.de",
      username: "testuser",
      password: "Supersecret123",
      password_confirm: "Supersecret123"
    }
    @invalid_attrs %{}

    test "with valid data inserts user" do
      assert {:ok, %User{id: id} = user} = Accounts.register_user(@valid_attrs)
      assert user.email == "test@test.de"
      assert user.username == "testuser"
      assert user.password == "Supersecret123"
      assert [%User{id: ^id}] = Accounts.list_users()
    end

    test "with invalid data dos not insert user" do
      assert {:error, _changeset} = Accounts.register_user(@invalid_attrs)
      assert [] = Accounts.list_users()
    end

    test "enforce unique emails" do
      assert {:ok, %User{id: id}} = Accounts.register_user(@valid_attrs)
      assert {:error, changeset} = Accounts.register_user(@valid_attrs)

      assert %{email: ["has already been taken"]} = errors_on(changeset)
      assert [%User{id: ^id}] = Accounts.list_users()
    end

    test "does not accept long usernames" do
      attrs = Map.put(@valid_attrs, :username, String.duplicate("a", 30))
      assert {:error, changeset} = Accounts.register_user(attrs)

      assert %{username: ["should be at most 15 character(s)"]} = errors_on(changeset)
      assert [] = Accounts.list_users()
    end

    test "requires password to be at least 8 chars long" do
      attrs =
        @valid_attrs
        |> Map.put(:password, "Secret1")
        |> Map.put(:password_confirm, "Secret1")

      assert {:error, changeset} = Accounts.register_user(attrs)
      assert %{password: ["should be at least 8 character(s)"]} = errors_on(changeset)
      assert [] = Accounts.list_users()
    end

    test "requires password to contain one upper-case, one lower-case letter and one digit" do
      attrs =
        @valid_attrs
        |> Map.put(:password, "supersecret1")
        |> Map.put(:password_confirm, "supersecret1")

      assert {:error, changeset} = Accounts.register_user(attrs)
      assert %{password: ["must contain one upper-case, one lower-case letter and one digit"]}
        = errors_on(changeset)
      assert [] = Accounts.list_users()
    end
  end

  describe "authenticate_by_username_and_pass/2" do
    @pass "SuperSecret123"
    @bad_pass "badpass"

    @unknow_user_email "unknow_user@user.com"

    setup do
      confirmed_user = user_fixture(%{password: @pass, password_confirm: @pass})

      unconfirmed_user = user_fixture(%{
        confirmed: false,
        email: "test2@test.de",
        password: @pass,
        password_confirm: @pass
      })

      {:ok,
        user: confirmed_user,
        unconfirmed_user: unconfirmed_user
      }
    end

    test "returns user with correct password", %{user: user} do
      assert {:ok, auth_user} =
        Accounts.authenticate_by_email_and_password(user.email, @pass)

      assert auth_user.id == user.id
    end

    test "returns unconfirmed error if user has not been confirmed yet", %{unconfirmed_user: user} do
      assert {:error, :unconfirmed} =
        Accounts.authenticate_by_email_and_password(user.email, @pass)
    end

    test "returns unauthorized error with invalid password", %{user: user} do
      assert {:error, :invalid_credentials} =
        Accounts.authenticate_by_email_and_password(user.email, @bad_pass)
    end

    test "returns not found error with no matching user for email" do
      assert {:error, :invalid_credentials} =
        Accounts.authenticate_by_email_and_password(@unknow_user_email, @pass)
    end
  end

  describe "groups" do
    alias Dsa.Accounts.Group

    @valid_attrs %{name: "TestGroup"}
    @invalid_attrs %{name: nil}

    setup do
      {:ok, user: user_fixture()}
    end

    test "create_group/2 with valid data creates a group", %{user: user} do
      assert {:ok, %Group{} = group} = Accounts.create_group(user, @valid_attrs)
      assert group.name == "TestGroup"
      assert group.master_id == user.id
    end

    test "create_group/2 with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_group(user, @invalid_attrs)
    end
  end
end
