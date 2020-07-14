defmodule DsaWeb.SessionControllerTest do
  use DsaWeb.ConnCase
  alias DsaWeb.Auth

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(DsaWeb.Router, :browser)
      |> get("/")

    {:ok, %{conn: conn}}
  end

  test "GET / anonymous visitors should be redirected to login", %{conn: conn} do
    conn = get(conn, "/")
    assert redirected_to(conn, 302) =~ "/login"
  end

  test "GET / authenticated visitors should be redirected to first group", %{conn: conn} do
    user = user_fixture()

    conn =
      conn
      |> Auth.login(user)
      |> send_resp(:ok, "")
      |> get("/")

    assert redirected_to(conn, 302) =~ Routes.live_path(conn, DsaWeb.GroupLive, 1)
  end
end
