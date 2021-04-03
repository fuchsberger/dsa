defmodule DsaWeb.DiceTableEntryControllerTest do
  use DsaWeb.ConnCase

  alias Dsa.DiceTableEntries

  @create_attrs %{dice: 42, text: "some text"}
  @update_attrs %{dice: 43, text: "some updated text"}
  @invalid_attrs %{dice: nil, text: nil}

  def fixture(:dice_table_entry) do
    {:ok, dice_table_entry} = DiceTableEntries.create_dice_table_entry(@create_attrs)
    dice_table_entry
  end

  describe "index" do
    test "lists all dice_table_entries", %{conn: conn} do
      conn = get(conn, Routes.dice_table_entry_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Dice table entries"
    end
  end

  describe "new dice_table_entry" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.dice_table_entry_path(conn, :new))
      assert html_response(conn, 200) =~ "New Dice table entry"
    end
  end

  describe "create dice_table_entry" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.dice_table_entry_path(conn, :create), dice_table_entry: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.dice_table_entry_path(conn, :show, id)

      conn = get(conn, Routes.dice_table_entry_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Dice table entry"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.dice_table_entry_path(conn, :create), dice_table_entry: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Dice table entry"
    end
  end

  describe "edit dice_table_entry" do
    setup [:create_dice_table_entry]

    test "renders form for editing chosen dice_table_entry", %{conn: conn, dice_table_entry: dice_table_entry} do
      conn = get(conn, Routes.dice_table_entry_path(conn, :edit, dice_table_entry))
      assert html_response(conn, 200) =~ "Edit Dice table entry"
    end
  end

  describe "update dice_table_entry" do
    setup [:create_dice_table_entry]

    test "redirects when data is valid", %{conn: conn, dice_table_entry: dice_table_entry} do
      conn = put(conn, Routes.dice_table_entry_path(conn, :update, dice_table_entry), dice_table_entry: @update_attrs)
      assert redirected_to(conn) == Routes.dice_table_entry_path(conn, :show, dice_table_entry)

      conn = get(conn, Routes.dice_table_entry_path(conn, :show, dice_table_entry))
      assert html_response(conn, 200) =~ "some updated text"
    end

    test "renders errors when data is invalid", %{conn: conn, dice_table_entry: dice_table_entry} do
      conn = put(conn, Routes.dice_table_entry_path(conn, :update, dice_table_entry), dice_table_entry: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Dice table entry"
    end
  end

  describe "delete dice_table_entry" do
    setup [:create_dice_table_entry]

    test "deletes chosen dice_table_entry", %{conn: conn, dice_table_entry: dice_table_entry} do
      conn = delete(conn, Routes.dice_table_entry_path(conn, :delete, dice_table_entry))
      assert redirected_to(conn) == Routes.dice_table_entry_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.dice_table_entry_path(conn, :show, dice_table_entry))
      end
    end
  end

  defp create_dice_table_entry(_) do
    dice_table_entry = fixture(:dice_table_entry)
    %{dice_table_entry: dice_table_entry}
  end
end
