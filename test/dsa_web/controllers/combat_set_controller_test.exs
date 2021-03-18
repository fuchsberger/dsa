defmodule DsaWeb.CombatSetControllerTest do
  use DsaWeb.ConnCase

  describe "combat sets" do
    alias Dsa.Characters
    alias Dsa.Characters.CombatSet

    @valid_attrs %{name: "TestSet", at: 10, pa: 10, tp_bonus: 0, tp_dice: 1, tp_type: 6}
    @invalid_attrs %{name: nil, at: nil, pa: nil, tp_bonus: nil, tp_dice: nil, tp_type: nil}

    setup %{conn: conn, login_as: username} do
      user = user_fixture(username: username)
      character = character_fixture(user)
      {:ok, conn: authenticate_user(assign(conn, :current_user, user)), character: character}
    end

    @tag login_as: "Max"
    test "list_combat_sets/1 returns all character combat sets", %{conn: conn, character: character} do

    end

  end
end
