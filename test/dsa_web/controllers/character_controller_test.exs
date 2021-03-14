defmodule DsaWeb.CharacterControllerTest do
  use DsaWeb.ConnCase, async: true

  alias Dsa.Characters

  describe "with a logged-in user" do
    setup %{conn: conn, login_as: username} do
      user = user_fixture(username: username)
      conn = assign(conn, :current_user, user)
      {:ok, conn: conn, user: user}
    end

    @tag login_as: "Testuser"
    test "lists all user's characters on index", %{conn: conn, user: user} do
      user_character  = character_fixture(user, name: "Gandalf")
      other_character = character_fixture(user_fixture(username: "Testuser2"), name: "Saruman")

      conn = get conn, Routes.character_path(conn, :index)
      response = html_response(conn, 200)
      assert response =~ gettext("Characters")
      assert response =~ user_character.name
      refute response =~ other_character.name
    end

    @tag login_as: "Testuser"
    test "GET /characters/new should should show the character create form", %{conn: conn} do
      conn = get conn, "/characters/new"
      assert html_response(conn, 200) =~ gettext("New Character")
    end

    @create_attrs %{name: "Gandalf", profession: "Wizard", le_max: 90, ae_max: 80, ke_max: 70, sp: 6, mu: 12, kl: 13, in: 14, ch: 15, ff: 16, ge: 17, ko: 18, kk: 19}
    @invalid_attrs %{ch: 10000}

    defp character_count, do: Enum.count(Characters.list())

    @tag login_as: "Testuser"
    test "creates user character and redirects", %{conn: conn, user: user} do
      create_conn = post conn, Routes.character_path(conn, :create), character: @create_attrs

      assert %{id: id} = redirected_params(create_conn)
      assert redirected_to(create_conn) == Routes.character_path(create_conn, :edit, id)

      conn = get conn, Routes.character_path(conn, :edit, id)
      assert html_response(conn, 200) =~ gettext("Edit Character")

      assert Characters.get!(id).user_id == user.id
    end

    @tag login_as: "Testuser"
    test "does not create character, renders errors when invalid", %{conn: conn} do
      count_before = character_count()
      conn = post conn, Routes.character_path(conn, :create), character: @invalid_attrs
      assert html_response(conn, 200) =~ gettext("New Character")
      assert character_count() == count_before
    end
  end

  test "requires user authentication on all /characters actions", %{conn: conn} do
    user = user_fixture()

    Enum.each([
      get(conn, Routes.character_path(conn, :index)),
      get(conn, Routes.character_path(conn, :new)),
      get(conn, Routes.character_path(conn, :edit, user)),
      put(conn, Routes.character_path(conn, :update, user, %{})),
      post(conn, Routes.character_path(conn, :create, %{})),
      delete(conn, Routes.character_path(conn, :delete, user)),
      put(conn, Routes.character_path(conn, :activate, user, %{})),
      put(conn, Routes.character_path(conn, :toggle_visible, user, %{})),
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end
end
