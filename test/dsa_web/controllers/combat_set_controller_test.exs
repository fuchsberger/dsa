defmodule DsaWeb.CombatSetControllerTest do
  use DsaWeb.ConnCase, async: true

  describe "with a logged in user and valid character" do

    setup %{conn: conn, login_as: username} do
      user = user_fixture(username: username)
      character = character_fixture(user)
      {:ok, conn: authenticate_user(assign(conn, :current_user, user)), character: character}
    end

    @tag login_as: "Max"
    test "lists all character's combat sets on index", %{conn: conn, character: character} do
      combat_set = combat_set_fixture(character, name: "Main")

      user = user_fixture(username: "Sam")
      character2 = character_fixture(user)
      other_set = combat_set_fixture(character2, name: "Alternativ")

      conn = get conn, Routes.character_combat_set_path(conn, :index, character)
      response = html_response(conn, 200)
      assert response =~ gettext("Combat Sets")
      assert response =~ combat_set.name
      refute response =~ other_set.name
    end

    alias Dsa.Characters

    @create_attrs %{name: "TestSet", at: 10, pa: 10, tp_bonus: 0, tp_dice: 1, tp_type: 6}
    @invalid_attrs %{name: nil}

    defp combat_set_count(character), do: Enum.count(Characters.list_combat_sets(character))

    @tag login_as: "max"
    test "creates combat sets and redirects", %{conn: conn, character: character} do
      create_conn =
        post conn, Routes.character_combat_set_path(conn, :create, character),
          combat_set: @create_attrs

      assert %{character_id: Integer.to_string(character.id)} == redirected_params(create_conn)
      assert redirected_to(create_conn) == Routes.character_combat_set_path(create_conn, :index, character)

      conn = get conn, Routes.character_combat_set_path(conn, :index, character)
      assert html_response(conn, 200) =~ gettext("Combat Sets")
      assert html_response(conn, 200) =~ @create_attrs.name
    end

    @tag login_as: "max"
    test "does not create combat set, renders errors when invalid", %{conn: conn, character: c} do
      count_before = combat_set_count(c)
      conn = post conn, Routes.character_combat_set_path(conn, :create, c),
        combat_set: @invalid_attrs
      assert html_response(conn, 200) =~ gettext "Oops, something went wrong! Please check the errors below."
      assert combat_set_count(c) == count_before
    end
  end

  # test "authorizes actions against access by other users", %{conn: conn} do
  #   owner = user_fixture(username: "owner")
  #   character = character_fixture(owner)
  #   combat_set = combat_set_fixture(character, @create_attrs)
  #   non_owner = user_fixture(username: "sneaky")
  #   conn = assign(conn, :current_user, non_owner)

  #   assert_error_sent :forbidden, fn ->
  #     get(conn, Routes.character_combat_set_path(conn, :show, character, combat_set))
  #   end
  #   assert_error_sent :forbidden, fn ->
  #     get(conn, Routes.character_combat_set_path(conn, :edit, character, combat_set))
  #   end
  #   assert_error_sent :forbidden, fn ->
  #     put(conn, Routes.character_combat_set_path(conn, :update, character, combat_set, combat_set: @create_attrs))
  #   end
  #   assert_error_sent :forbidden, fn ->
  #     delete(conn, Routes.character_combat_set_path(conn, :delete, character, combat_set))
  #   end
  # end

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each([
      get(conn, Routes.character_combat_set_path(conn, :index, 1)),
      get(conn, Routes.character_combat_set_path(conn, :new, 1)),
      post(conn, Routes.character_combat_set_path(conn, :create, 1)),
      delete(conn, Routes.character_combat_set_path(conn, :delete, 1, 123)),
      get(conn, Routes.character_combat_set_path(conn, :edit, 1, 123)),
      put(conn, Routes.character_combat_set_path(conn, :update, 1, 123))
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end
end
