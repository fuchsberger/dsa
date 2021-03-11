defmodule DsaWeb.GroupControllerTest do
  use DsaWeb.ConnCase

  alias Dsa.Accounts

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each([
      delete(conn, Routes.group_path(conn, :leave)),
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  test "DELETE /group/leave when user has joined a group", %{conn: conn} do
    %{id: id} = group_fixture()
    user = user_fixture()
    {:ok, user} = Accounts.update_user(user, %{group_id: id})
    conn = assign(conn, :current_user, user)
    conn = delete conn, "/group/leave"
    assert user.group_id == id
    assert redirected_to(conn) =~ "/user/#{user.id}/edit"
  end

  test "DELETE /group/leave when user has not joined a group", %{conn: conn} do
    user = user_fixture()
    conn = assign(conn, :current_user, user)
    conn = delete conn, "/group/leave"
    assert redirected_to(conn) =~ "/user/#{user.id}/edit"
  end
end
