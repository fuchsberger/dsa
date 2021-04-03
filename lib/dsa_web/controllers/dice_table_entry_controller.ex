defmodule DsaWeb.DiceTableEntryController do
  use DsaWeb, :controller

  alias Dsa.DiceTableEntries
  alias Dsa.DiceTableEntries.DiceTableEntry
  alias Dsa.DiceTables

  def index(conn, %{"dice_table_id" => table_id}) do
    dice_table_entries = DiceTableEntries.list_dice_table_entries(table_id)
    render(conn, "index.html", dice_table_entries: dice_table_entries, table_id: table_id)
  end

  def new(conn, %{"dice_table_id" => table_id}) do
    changeset = DiceTableEntries.change_dice_table_entry(%DiceTableEntry{})
    render(conn, "new.html", changeset: changeset, table_id: table_id)
  end

  def create(conn, %{"dice_table_entry" => dice_table_entry_params, "dice_table_id" => table_id}) do
    case DiceTableEntries.create_dice_table_entry(dice_table_entry_params) do
      {:ok, dice_table_entry} ->
        conn
        |> put_flash(:info, "Dice table entry created successfully.")
        |> redirect(to: Routes.dice_table_dice_table_entry_path(conn, :show, table_id, dice_table_entry))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id, "dice_table_id" => table_id}) do
    dice_table_entry = DiceTableEntries.get_dice_table_entry!(id)
    render(conn, "show.html", dice_table_entry: dice_table_entry, table_id: table_id)
  end

  def edit(conn, %{"id" => id}) do
    dice_table_entry = DiceTableEntries.get_dice_table_entry!(id)
    changeset = DiceTableEntries.change_dice_table_entry(dice_table_entry)
    render(conn, "edit.html", dice_table_entry: dice_table_entry, changeset: changeset)
  end

  def update(conn, %{"id" => id, "dice_table_entry" => dice_table_entry_params}) do
    dice_table_entry = DiceTableEntries.get_dice_table_entry!(id)

    case DiceTableEntries.update_dice_table_entry(dice_table_entry, dice_table_entry_params) do
      {:ok, dice_table_entry} ->
        conn
        |> put_flash(:info, "Dice table entry updated successfully.")
        |> redirect(to: Routes.dice_table_entry_path(conn, :show, dice_table_entry))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", dice_table_entry: dice_table_entry, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    dice_table_entry = DiceTableEntries.get_dice_table_entry!(id)
    {:ok, _dice_table_entry} = DiceTableEntries.delete_dice_table_entry(dice_table_entry)

    conn
    |> put_flash(:info, "Dice table entry deleted successfully.")
    |> redirect(to: Routes.dice_table_entry_path(conn, :index))
  end
end
