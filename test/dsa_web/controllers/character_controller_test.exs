defmodule DsaWeb.CharacterControllerTest do
  use DsaWeb.ConnCase, async: true

  import Dsa.AccountsFixtures
  import Dsa.GameFixtures

  alias Dsa.{Accounts, Game, Repo}

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
    test "POST /helden creates user character, activates it and redirects", %{conn: conn, user: user} do

      assert is_nil(user.active_character_id)

      count_before = character_count(user)
      create_conn = post conn, Routes.character_path(conn, :create), character: @create_attrs
      count_after = character_count(user)

      refute is_nil(Accounts.get_user!(user.id).active_character_id)
      assert redirected_to(create_conn) == Routes.character_path(create_conn, :index)
      assert count_before + 1 == count_after
    end

    @alternative_attrs %{name: "Saruman", profession: "Wizard"}
    test "POST /helden does not activate user if already activated", %{conn: conn, user: user} do
      character  = character_fixture(user, name: "Gandalf")
      {:ok, user} = Game.select_character(user, character)

      assert user.active_character_id == character.id
      post conn, Routes.character_path(conn, :create), character: @alternative_attrs
      updated_user = Accounts.get_user!(user.id)
      assert updated_user.active_character_id == character.id
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

  describe "DELETE /helden/:id" do
    setup [:register_and_log_in_user]

    test "deletes an owned character", %{conn: conn, user: user} do
      character = character_fixture(user)

      conn = delete(conn, Routes.character_path(conn, :delete, character))
      assert redirected_to(conn) == Routes.character_path(conn, :index)
      # TODO: enable if there is a character show page
      # assert_error_sent 404, fn ->
      #   get(conn, Routes.character_path(conn, :show, skill))
      # end
    end

    test "does show an error page if character does not exist", %{conn: conn} do
      conn = delete(conn, Routes.character_path(conn, :delete, 70))
      assert html_response(conn, 404)
    end

    test "does show an error page if character is not owned", %{conn: conn} do
      other_user = user_fixture()
      character = character_fixture(other_user)

      conn = delete(conn, Routes.character_path(conn, :delete, character))
      assert html_response(conn, 403)
    end
  end

  describe "requires user authentication" do
    setup [:create_character]

    test "on all /characters actions", %{conn: conn, character: character} do
      Enum.each([
        get(conn, Routes.character_path(conn, :index)),
        post(conn, Routes.character_path(conn, :create, %{})),
        delete(conn, Routes.character_path(conn, :delete, character))
      ], fn conn ->
        assert html_response(conn, 302)
        assert conn.halted
        assert redirected_to(conn) == Routes.user_session_path(conn, :new)
      end)
    end
  end

  defp create_character(_) do
    user = user_fixture()
    %{user: user, character: character_fixture(user)}
  end

  defp character_count(user) do
    user
    |> Repo.preload(:characters, force: true)
    |> Map.get(:characters)
    |> Enum.count()
  end
end
