defmodule Dsa.GameTest do
  use Dsa.DataCase

  import Dsa.AccountsFixtures
  import Dsa.GameFixtures

  alias Dsa.Game
  alias Dsa.Game.Character

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

      assert %{
        name: ["can't be blank"],
        profession: ["can't be blank"]
      } = errors_on(changeset)
    end

    test "fills required and default character data correctly", %{user: user} do
      character = character_fixture(user)

      assert character.name == "Ethric"
      assert character.profession == "Elementarmagier"
      assert character.active == true
      assert %{skills: %{skill_1: 0}} = Jason.decode!(character.data, keys: :atoms)
    end
  end

  describe "activate_character/2" do
    setup do
      user = user_fixture()
      %{
        user: user,
        character: character_fixture(user)
      }
    end

    test "activates a character if it belongs to the user", %{user: user, character: character} do
      assert is_nil(user.active_character_id)

      {:ok, user} = Game.activate_character(user, character)
      assert user.active_character_id == character.id
    end

    test "does not activate characters that do not belong to user", %{character: character} do
      invalid_user = user_fixture()
      assert {:error, :permission_denied} = Game.activate_character(invalid_user, character)
    end
  end
end
