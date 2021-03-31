defmodule DsaWeb.SessionControllerTest do
  use DsaWeb.ConnCase

  @valid_attributes [email: "test@test.de", password: "Supersecret123", redirect: "/login"]
  @invalid_attributes [confirmed: false, email: "test2@test.de", password: "Supersecret123", redirect: "/login"]

  test "GET / without authentication", %{conn: conn} do
    conn = get conn, "/"
    assert redirected_to(conn) =~ "/login"
  end

  test "GET / with valid user", %{conn: conn} do
    user = user_fixture(@valid_attributes)
    conn = assign(conn, :current_user, user)
    conn = get conn, "/"
    assert redirected_to(conn) =~ "/characters"
  end

  test "GET /login with authenticated users redirects to /characters", %{conn: conn} do
    user = user_fixture(@valid_attributes)
    conn = assign(conn, :current_user, user)
    conn = get conn, "/login"
    assert redirected_to(conn) =~ "/characters"
  end

  test "GET /login", %{conn: conn} do
    conn = get conn, "/login"
    assert html_response(conn, 200) =~ "<form action=\"/login\""
  end

  test "POST /login with valid attributes", %{conn: conn} do
    user_fixture(@valid_attributes)
    conn = post conn, "/login", session: @valid_attributes
    assert redirected_to(conn) =~ "/login"
  end

  test "POST /login with unconfirmed user", %{conn: conn} do
    user_fixture(@invalid_attributes)
      _conn = post conn, "/login", session: @invalid_attributes
    # assert unconfirmed_response(conn) TODO: perhaps also check that user is not authenticated
  end

  test "POST /login with invalid credentials", %{conn: conn} do
    user_fixture(@valid_attributes)
    conn = post conn, "/login", session: %{email: "test@test.de", password: "invalid", redirect: "/login"}

    assert get_flash(conn, :error) == gettext("Invalid Login Data.")
    assert html_response(conn, 200) =~ "<form action=\"/login\""
  end

  test "DELETE /logout/:user_id when authenticated", %{conn: conn} do
    user = user_fixture(@valid_attributes)
    conn = assign(conn, :current_user, user)
    conn = delete conn, "/logout/#{user.id}"
    assert redirected_to(conn) =~ "/login"
  end

  test "DELETE /logout/:user_id when not authenticated", %{conn: conn} do
    %{id: id} = user_fixture(@valid_attributes)
    conn = delete conn, "/logout/#{id}"
    assert unauthorized_response(conn)
  end
end
