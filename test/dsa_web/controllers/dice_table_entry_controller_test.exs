defmodule DsaWeb.DiceTableEntryControllerTest do
  use DsaWeb.ConnCase

  alias Dsa.DiceTableEntries
  alias Dsa.DiceTables


  @create_table_attrs %{table_name: "some table_name"}
  @create_attrs %{result: "some result", description: "some text"}
  @update_attrs %{result: "some better result", description: "some updated text"}
  @invalid_attrs %{dice: nil, text: nil}
  @table_id 123

  def fixture(:dice_table_entry) do
    table = fixture(:dice_table)

    {:ok, dice_table_entry} = DiceTableEntries.create_dice_table_entry(@create_attrs, table.id)

    dice_table_entry
  end

  def fixture(:dice_table) do
    {:ok, dice_table} = DiceTables.create_dice_table(@create_table_attrs)
    dice_table
  end

  describe "index" do
    setup [:create_dice_table_entry]
    test "lists all dice_table_entries", %{conn: conn} do
      table_id = Enum.random(Dsa.DiceTables.list_dice_tables).id
      conn = get(conn, Routes.dice_table_dice_table_entry_path(conn, :index, table_id))
      assert html_response(conn, 200) =~ "Result"
    end
  end

  describe "new dice_table_entry" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.dice_table_dice_table_entry_path(conn, :new, @table_id))
      assert html_response(conn, 200) =~ "New Dice table entry"
    end
  end


  describe "create dice_table_entry" do
    setup [:create_dice_table]


    @tag :skip
    test "redirects to show when data is valid", %{conn: conn, dice_table_entry: dice_table_entry} do
      conn = post(conn, Routes.dice_table_dice_table_entry_path(conn, :create, dice_table_entry.dice_table_id, dice_table_entry: @create_attrs))

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.dice_table_entry_path(conn, :show, dice_table_entry.dice_table_id, id)

      conn = get(conn, Routes.dice_table_entry_path(conn, :show, dice_table_entry.dice_table_id, id))
      assert html_response(conn, 200) =~ "Show Dice table entry"
    end


    @tag :skip
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.dice_table_dice_table_entry_path(conn, :create, @table_id), dice_table_entry: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Dice table entry"
    end
  end

  describe "edit dice_table_entry" do
    setup [:create_dice_table_entry]

    test "renders form for editing chosen dice_table_entry", %{conn: conn, dice_table_entry: dice_table_entry} do
      conn = get(conn, Routes.dice_table_dice_table_entry_path(conn, :edit, @table_id, dice_table_entry))
      assert html_response(conn, 200) =~ "Edit entry"
    end
  end

  describe "update dice_table_entry" do
    setup [:create_dice_table_entry]

    @tag :skip
    test "redirects when data is valid", %{conn: conn, dice_table_entry: dice_table_entry} do
      conn = put(conn, Routes.dice_table_dice_table_entry_path(conn, :update, @table_id, dice_table_entry), dice_table_entry: @update_attrs)
      assert redirected_to(conn) == Routes.dice_table_dice_table_entry_path(conn, :show, @table_id, dice_table_entry)

      conn = get(conn, Routes.dice_table_dice_table_entry_path(conn, :show, @table_id, dice_table_entry))
      assert html_response(conn, 200) =~ "some updated text"
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn, dice_table_entry: dice_table_entry} do
      conn = put(conn, Routes.dice_table_dice_table_entry_path(conn, :update,dice_table_entry.dice_table_id, dice_table_entry), dice_table_entry: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit entry"
    end
  end

  @tag :skip
  describe "delete dice_table_entry" do
    setup [:create_dice_table_entry]

    test "deletes chosen dice_table_entry", %{conn: conn, dice_table_entry: dice_table_entry} do
      conn = delete(conn, Routes.dice_table_dice_table_entry_path(conn, :delete, dice_table_entry.dice_table_id, dice_table_entry))
      assert redirected_to(conn) == Routes.dice_table_dice_table_entry_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.dice_table_entry_path(conn, :show, @table_id, dice_table_entry))
      end
    end
  end

  defp create_dice_table_entry(_) do
    dice_table_entry = fixture(:dice_table_entry)
    
    %{dice_table_entry: dice_table_entry}
  end

  defp create_dice_table(_) do
    dice_table = fixture(:dice_table)
    %{dice_table: dice_table}
  end
end
