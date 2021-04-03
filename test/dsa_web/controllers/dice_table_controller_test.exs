defmodule DsaWeb.DiceTableControllerTest do
  use DsaWeb.ConnCase

  alias Dsa.DiceTables

  @create_attrs %{table_name: "some table_name"}
  @update_attrs %{table_name: "some updated table_name"}
  @invalid_attrs %{table_name: nil}

  def fixture(:dice_table) do
    {:ok, dice_table} = DiceTables.create_dice_table(@create_attrs)
    dice_table
  end

  describe "index" do
    test "lists all dice_tables", %{conn: conn} do
      conn = get(conn, Routes.dice_table_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Dice tables"
    end
  end

  describe "new dice_table" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.dice_table_path(conn, :new))
      assert html_response(conn, 200) =~ "New Dice table"
    end
  end

  describe "create dice_table" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.dice_table_path(conn, :create), dice_table: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.dice_table_path(conn, :show, id)

      conn = get(conn, Routes.dice_table_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Dice table"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.dice_table_path(conn, :create), dice_table: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Dice table"
    end
  end

  describe "edit dice_table" do
    setup [:create_dice_table]

    test "renders form for editing chosen dice_table", %{conn: conn, dice_table: dice_table} do
      conn = get(conn, Routes.dice_table_path(conn, :edit, dice_table))
      assert html_response(conn, 200) =~ "Edit Dice table"
    end
  end

  describe "update dice_table" do
    setup [:create_dice_table]

    test "redirects when data is valid", %{conn: conn, dice_table: dice_table} do
      conn = put(conn, Routes.dice_table_path(conn, :update, dice_table), dice_table: @update_attrs)
      assert redirected_to(conn) == Routes.dice_table_path(conn, :show, dice_table)

      conn = get(conn, Routes.dice_table_path(conn, :show, dice_table))
      assert html_response(conn, 200) =~ "some updated table_name"
    end

    test "renders errors when data is invalid", %{conn: conn, dice_table: dice_table} do
      conn = put(conn, Routes.dice_table_path(conn, :update, dice_table), dice_table: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Dice table"
    end
  end

  describe "delete dice_table" do
    setup [:create_dice_table]

    test "deletes chosen dice_table", %{conn: conn, dice_table: dice_table} do
      conn = delete(conn, Routes.dice_table_path(conn, :delete, dice_table))
      assert redirected_to(conn) == Routes.dice_table_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.dice_table_path(conn, :show, dice_table))
      end
    end
  end

  defp create_dice_table(_) do
    dice_table = fixture(:dice_table)
    %{dice_table: dice_table}
  end
end
