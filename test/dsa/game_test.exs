defmodule Dsa.GameTest do
  use Dsa.DataCase

  import Dsa.AccountsFixtures
  import Dsa.GameFixtures

  alias Dsa.Game
  alias Dsa.Game.Character

  describe "" do
    setup do
      user = user_fixture()
      %{character: character_fixture(user)}
    end

    test "get_character!/1 returns character with given id", %{character: %Character{id: id}} do
      assert %Character{id: ^id} = Game.get_character!(id)
    end

    test "delete_character/1 deletes the character", %{character: character} do
      assert {:ok, %Character{id: id}} = Game.delete_character(character)
      assert catch_error Game.get_character!(id)
    end
  end

  describe "change_character/2" do
    test "returns a character changeset" do
      assert %Ecto.Changeset{} = changeset = Game.change_character(%Character{})
      assert changeset.required == [:name, :profession]
    end
  end

  describe "fetch_character/1" do
    test "returns a {:ok, character} tuple if the character exists" do
      user = user_fixture()
      %Character{id: id} = character = character_fixture(user)
      assert {:ok, returned_character} = Game.fetch_character(id)
      assert character.id == returned_character.id
    end

    test "returns a {:error, :character_not_found} tuple if the character does not exist" do
      assert {:error, :character_not_found} = Game.fetch_character(666)
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

  describe "select_character/2" do
    setup do
      user = user_fixture()
      %{
        user: user,
        character: character_fixture(user)
      }
    end

    test "activates a character if it belongs to the user", %{user: user, character: character} do
      assert is_nil(user.active_character_id)

      {:ok, user} = Game.select_character(user, character)
      assert user.active_character_id == character.id
    end

    test "does not activate characters that do not belong to user", %{character: character} do
      invalid_user = user_fixture()
      assert {:error, :permission_denied} = Game.select_character(invalid_user, character)
    end
  end
end
