defmodule DsaWeb.CharacterControllerTest do
  use DsaWeb.ConnCase

  test "GET / redirects to login page if not authenticated", %{conn: conn} do
    conn = get conn, "/"
    assert redirected_to(conn) =~ "/sessions/new"
  end

  describe "with a logged-in user" do
    setup  %{conn: conn, login_as: username} do
      user = user_fixture(username: username)
      conn = assign(conn, :current_user, user)
      {:ok, conn: conn, user: user}
    end

    @tag login_as: "test_user"
    test "GET / should redirect to character index page", %{conn: conn, user: user} do
      conn = get conn, "/"
      assert redirected_to(conn) =~ "/characters"
    end
  end
end
