defmodule DsaWeb.CharacterControllerTest do
  use DsaWeb.ConnCase, async: true

  import Dsa.AccountsFixtures
  import Dsa.GameFixtures

  alias Dsa.Repo

  describe "with a logged-in user" do
    setup :register_and_log_in_user

    test "GET /helden lists all user's characters", %{conn: conn, user: user} do
      user_character  = character_fixture(user, name: "Gandalf")
      other_character = character_fixture(user_fixture(username: "Testuser2"), name: "Saruman")

      conn = get conn, Routes.character_path(conn, :index)

      response = html_response(conn, 200)
      assert response =~ gettext("Heldenübersicht")
      assert response =~ user_character.name
      refute response =~ other_character.name
    end

    @create_attrs %{name: "Gandalf", profession: "Wizard"}
    test "POST /helden creates user character and redirects", %{conn: conn, user: user} do

      count_before = character_count(user)

      create_conn = post conn, Routes.character_path(conn, :create), character: @create_attrs

      count_after = character_count(user)

      assert redirected_to(create_conn) == Routes.character_path(create_conn, :index)
      assert count_before + 1 == count_after
    end

    @invalid_attrs %{name: "Saruman"}
    test "does not create character, renders errors when invalid", %{conn: conn, user: user} do
      count_before = character_count(user)
      conn = post conn, Routes.character_path(conn, :create), character: @invalid_attrs
      assert html_response(conn, 200) =~ gettext("Heldenübersicht")
      assert html_response(conn, 200) =~ "validated"
      assert html_response(conn, 200) =~ "invalid"

      count_after = character_count(user)
      assert count_after == count_before
    end
  end

  test "requires user authentication on all /characters actions", %{conn: conn} do
    Enum.each([
      get(conn, Routes.character_path(conn, :index)),
      post(conn, Routes.character_path(conn, :create, %{}))
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  defp character_count(user) do
    user
    |> Repo.preload(:characters, force: true)
    |> Map.get(:characters)
    |> Enum.count()
  end
end
