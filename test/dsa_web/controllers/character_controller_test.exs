defmodule DsaWeb.CharacterControllerTest do
  use DsaWeb.ConnCase

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each([
      get(conn, Routes.character_path(conn, :index)),
      get(conn, Routes.character_path(conn, :new)),
      get(conn, Routes.character_path(conn, :edit, "123")),
      put(conn, Routes.character_path(conn, :update, "123", %{})),
      post(conn, Routes.character_path(conn, :create, %{})),
      delete(conn, Routes.character_path(conn, :delete, "123")),
      put(conn, Routes.character_path(conn, :activate, "123", %{})),
      put(conn, Routes.character_path(conn, :toggle_visible, "123", %{})),
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  describe "with a logged-in user" do
    setup  %{conn: conn, login_as: username} do
      user = user_fixture(%{username: username})
      conn = assign(conn, :current_user, user)
      {:ok, conn: conn, user: user}
    end

    @tag login_as: "test_user"
    test "GET / should redirect to character index page", %{conn: conn} do
      conn = get conn, "/"
      assert redirected_to(conn) =~ "/characters"
    end
  end
end
