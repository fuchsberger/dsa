defmodule Dsa.GameTest do
  use Dsa.DataCase

  import Dsa.AccountsFixtures
  import DsaWeb.Gettext

  alias Dsa.Game
  alias Dsa.Game.Character

  require Logger

  describe "change_character/2" do
    test "returns a character changeset" do
      assert %Ecto.Changeset{} = changeset = Game.change_character(%Character{})
      assert changeset.required == [:name, :profession]
    end
  end

  describe "create_character/2" do
    setup do
      %{user: user_fixture()}
    end

    test "requires name and profession to be set", %{user: user} do
      {:error, changeset} = Game.create_character(user, %{})

      Logger.warn inspect dgettext("errors", "can't be blank")

      assert %{
        name: ["can't be blank"],
        profession: ["can't be blank"]
      } = errors_on(changeset)
    end

    # test "validates username, email and password when given" do
    #   {:error, changeset} =
    #     Accounts.register_user(%{
    #       username: "",
    #       email: "not valid",
    #       password: "not valid",
    #       password_confirmation: "not matching"
    #     })

    #   assert %{
    #     username: ["can\'t be blank"],
    #     email: ["has invalid format"],
    #     password: ["should be at least 12 character(s)"],
    #     password_confirmation: ["does not match confirmation"]
    #   } = errors_on(changeset)
    # end

    # test "validates maximum values for email and password for security" do
    #   too_long = String.duplicate("db", 100)
    #   {:error, changeset} = Accounts.register_user(%{email: too_long, password: too_long})
    #   assert "should be at most 160 character(s)" in errors_on(changeset).email
    #   assert "should be at most 80 character(s)" in errors_on(changeset).password
    # end

    # test "validates email uniqueness" do
    #   %{email: email} = user_fixture()
    #   {:error, changeset} = Accounts.register_user(%{email: email})
    #   assert "has already been taken" in errors_on(changeset).email

    #   # Now try with the upper cased email too, to check that email case is ignored.
    #   {:error, changeset} = Accounts.register_user(%{email: String.upcase(email)})
    #   assert "has already been taken" in errors_on(changeset).email
    # end

    # test "registers users with a hashed password" do
    #   email = unique_user_email()

    #   {:ok, user} =
    #     Accounts.register_user(%{
    #       username: valid_user_username(),
    #       email: email,
    #       password: valid_user_password(),
    #       password_confirmation: valid_user_password()
    #     })

    #   assert user.email == email
    #   assert is_binary(user.hashed_password)
    #   assert is_nil(user.confirmed_at)
    #   assert is_nil(user.password)
    # end
  end

end
