defmodule DsaWeb.SessionControllerTest do
  use DsaWeb.ConnCase, async: true

  test "GET /", %{conn: conn} do
    conn = conn |> assign(:current_user, %{id: 23}) |> get("/")

    # IO.inspect {conn.assigns, redirected_to(conn, 302)}
    assert redirected_to(conn, 302) =~ "/login"
    # assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end
