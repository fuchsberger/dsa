defmodule Dsa.DiceTables do
  @moduledoc """
  The DiceTables context.
  """

  import Ecto.Query, warn: false
  alias Dsa.Repo

  alias Dsa.DiceTables.DiceTable

  @doc """
  Returns the list of dice_tables.

  ## Examples

      iex> list_dice_tables()
      [%DiceTable{}, ...]

  """
  def list_dice_tables do
    Repo.all(DiceTable)
  end

  @doc """
  Gets a single dice_table.

  Raises `Ecto.NoResultsError` if the Dice table does not exist.

  ## Examples

      iex> get_dice_table!(123)
      %DiceTable{}

      iex> get_dice_table!(456)
      ** (Ecto.NoResultsError)

  """
  def get_dice_table!(id), do: Repo.get!(DiceTable, id)

  @doc """
  Creates a dice_table.

  ## Examples

      iex> create_dice_table(%{field: value})
      {:ok, %DiceTable{}}

      iex> create_dice_table(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_dice_table(attrs \\ %{}) do
    %DiceTable{}
    |> DiceTable.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a dice_table.

  ## Examples

      iex> update_dice_table(dice_table, %{field: new_value})
      {:ok, %DiceTable{}}

      iex> update_dice_table(dice_table, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_dice_table(%DiceTable{} = dice_table, attrs) do
    dice_table
    |> DiceTable.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a dice_table.

  ## Examples

      iex> delete_dice_table(dice_table)
      {:ok, %DiceTable{}}

      iex> delete_dice_table(dice_table)
      {:error, %Ecto.Changeset{}}

  """
  def delete_dice_table(%DiceTable{} = dice_table) do
    Repo.delete(dice_table)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking dice_table changes.

  ## Examples

      iex> change_dice_table(dice_table)
      %Ecto.Changeset{data: %DiceTable{}}

  """
  def change_dice_table(%DiceTable{} = dice_table, attrs \\ %{}) do
    DiceTable.changeset(dice_table, attrs)
  end
end
