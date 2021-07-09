defmodule DsaWeb.DiceTableController do
  use DsaWeb, :controller

  alias Dsa.DiceTables
  alias Dsa.DiceTables.DiceTable

  def index(conn, _params) do
    dice_tables = DiceTables.list_dice_tables()
    render(conn, "index.html", dice_tables: dice_tables)
  end

  def new(conn, _params) do
    changeset = DiceTables.change_dice_table(%DiceTable{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"dice_table" => dice_table_params}) do
    case DiceTables.create_dice_table(dice_table_params) do
      {:ok, dice_table} ->
        conn
        |> put_flash(:info, "Dice table created successfully.")
        |> redirect(to: Routes.dice_table_path(conn, :show, dice_table))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    dice_table = DiceTables.get_dice_table!(id)
    render(conn, "show.html", dice_table: dice_table)
  end

  def edit(conn, %{"id" => id}) do
    dice_table = DiceTables.get_dice_table!(id)
    changeset = DiceTables.change_dice_table(dice_table)
    render(conn, "edit.html", dice_table: dice_table, changeset: changeset)
  end

  def update(conn, %{"id" => id, "dice_table" => dice_table_params}) do
    dice_table = DiceTables.get_dice_table!(id)

    case DiceTables.update_dice_table(dice_table, dice_table_params) do
      {:ok, dice_table} ->
        conn
        |> put_flash(:info, "Dice table updated successfully.")
        |> redirect(to: Routes.dice_table_path(conn, :show, dice_table))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", dice_table: dice_table, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    dice_table = DiceTables.get_dice_table!(id)
    {:ok, _dice_table} = DiceTables.delete_dice_table(dice_table)

    conn
    |> put_flash(:info, "Dice table deleted successfully.")
    |> redirect(to: Routes.dice_table_path(conn, :index))
  end
end
