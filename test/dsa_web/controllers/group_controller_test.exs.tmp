defmodule DsaWeb.GroupControllerTest do
  use DsaWeb.ConnCase, async: true

  test "index/2 should show list of groups", %{conn: conn} do
    conn = get conn, "/groups"
    assert html_response(conn, 200) =~ gettext("Groups")
    refute html_response(conn, 200) =~ gettext("New Group")
  end


  describe "with a logged-in user" do
    alias Dsa.Accounts

    @create_attrs %{name: "TestGroup"}
    @invalid_attrs %{name: nil}

    setup %{conn: conn, login_as: username} do
      user = user_fixture(username: username)
      {:ok, conn: authenticate_user(assign(conn, :current_user, user)), user: user}
    end

    defp group_count, do: Enum.count(Accounts.list_groups())

    @tag login_as: "max"
    test "index/2 should always show New Group button", %{conn: conn} do
      conn = get conn, "/groups"
      assert html_response(conn, 200) =~ gettext("Groups")
      assert html_response(conn, 200) =~ gettext("New Group")
    end

    @tag login_as: "max"
    test "index/2 should allow to join but not manage other group", %{conn: conn} do
      user2 = user_fixture()
      group_fixture(user2, name: "Wraiths")

      conn = get conn, "/groups"
      assert html_response(conn, 200) =~ gettext("Groups")
      assert html_response(conn, 200) =~ gettext("Wraiths")
      assert html_response(conn, 200) =~ gettext("Join")
      refute html_response(conn, 200) =~ gettext("Edit")
      refute html_response(conn, 200) =~ gettext("Delete")
    end

    @tag login_as: "max"
    test "index/2 should allow to leave and manage own group", %{conn: conn, user: user} do
      group = group_fixture(user, @create_attrs)
      {:ok, user} = Accounts.join_group(user, group)

      conn = assign(conn, :current_user, user)
      conn = get conn, "/groups"
      assert html_response(conn, 200) =~ gettext("Leave")
      assert html_response(conn, 200) =~ gettext("Edit")
      assert html_response(conn, 200) =~ gettext("Delete")
    end

    @tag login_as: "max"
    test "create group and redirect", %{conn: conn, user: %{id: user_id}} do

      create_conn = post conn, "/groups", group: @create_attrs

      assert %{id: group_id} = redirected_params(create_conn)
      assert redirected_to(create_conn) == "/groups/#{group_id}"

      conn = get conn, "/groups/#{group_id}"
      assert html_response(conn, 200)

      assert Accounts.get_group!(group_id).master_id == user_id
    end

    @tag login_as: "max"
    test "does not create group, renders errors when invalid", %{conn: conn} do
      count_before = group_count()
      conn = post conn, Routes.group_path(conn, :create), group: @invalid_attrs
      assert html_response(conn, 200) # TODO: verify content =~ "check the errors"
      assert group_count() == count_before
    end

    @tag login_as: "max"
    test "delete group if master or admin", %{conn: _conn, user: _user} do
      # TODO

    end

    @tag login_as: "max"
    test "join group and redirect", %{conn: conn, user: user} do

      group = group_fixture(user, @create_attrs)

      conn = put conn, Routes.group_path(conn, :join, group)
      assert redirected_to(conn) =~ "/groups/#{group.id}"

      assert Accounts.get_user!(user.id).group_id == group.id
    end

    @tag login_as: "max"
    test "leave group and redirect", %{conn: conn, user: user} do
      group = group_fixture(user)
      {:ok, user} = Accounts.join_group(user, group)
      assert user.group_id == group.id

      conn = delete conn, "/groups/leave"
      # assert is_nil(Accounts.get_user!(user.id).group_id) TODO: Fix
      assert redirected_to(conn) =~ "/groups"
    end
  end

  test "requires user authentication on most actions", %{conn: conn} do
    Enum.each([
      get(conn, Routes.group_path(conn, :new)),
      post(conn, Routes.group_path(conn, :create)),
      delete(conn, Routes.group_path(conn, :leave)),
      get(conn, Routes.group_path(conn, :edit, 123)),
      put(conn, Routes.group_path(conn, :join, 123))
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end
end
