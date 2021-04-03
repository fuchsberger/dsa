defmodule Dsa.DiceTableEntries do
  @moduledoc """
  The DiceTableEntries context.
  """

  import Ecto.Query, warn: false
  alias Dsa.Repo

  alias Dsa.DiceTableEntries.DiceTableEntry

  @doc """
  Returns the list of dice_table_entries.

  ## Examples

      iex> list_dice_table_entries()
      [%DiceTableEntry{}, ...]

  """
  def list_dice_table_entries(table_id) do
    Repo.all(from t in DiceTableEntry, where: t.dice_table_id == ^table_id)
  end

  @doc """
  Gets a single dice_table_entry.

  Raises `Ecto.NoResultsError` if the Dice table entry does not exist.

  ## Examples

      iex> get_dice_table_entry!(123)
      %DiceTableEntry{}

      iex> get_dice_table_entry!(456)
      ** (Ecto.NoResultsError)

  """
  def get_dice_table_entry!(id), do: Repo.get!(DiceTableEntry, id)

  @doc """
  Creates a dice_table_entry.

  ## Examples

      iex> create_dice_table_entry(%{field: value})
      {:ok, %DiceTableEntry{}}

      iex> create_dice_table_entry(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_dice_table_entry(attrs \\ %{}, table_id) do
    attrs = Map.merge(attrs, %{dice_table_id: table_id}) |> key_to_atom

    %DiceTableEntry{}
    |> DiceTableEntry.changeset(attrs)
    |> Repo.insert()
  end

  defp key_to_atom(map) do
    Enum.reduce(map, %{}, fn
      {key, value}, acc when is_atom(key) -> Map.put(acc, key, value)
      {key, value}, acc when is_binary(key) -> Map.put(acc, String.to_existing_atom(key), value)
    end)
  end

  @doc """
  Updates a dice_table_entry.

  ## Examples

      iex> update_dice_table_entry(dice_table_entry, %{field: new_value})
      {:ok, %DiceTableEntry{}}

      iex> update_dice_table_entry(dice_table_entry, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_dice_table_entry(%DiceTableEntry{} = dice_table_entry, attrs) do
    dice_table_entry
    |> DiceTableEntry.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a dice_table_entry.

  ## Examples

      iex> delete_dice_table_entry(dice_table_entry)
      {:ok, %DiceTableEntry{}}

      iex> delete_dice_table_entry(dice_table_entry)
      {:error, %Ecto.Changeset{}}

  """
  def delete_dice_table_entry(%DiceTableEntry{} = dice_table_entry) do
    Repo.delete(dice_table_entry)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking dice_table_entry changes.

  ## Examples

      iex> change_dice_table_entry(dice_table_entry)
      %Ecto.Changeset{data: %DiceTableEntry{}}

  """
  def change_dice_table_entry(%DiceTableEntry{} = dice_table_entry, attrs \\ %{}) do
    DiceTableEntry.changeset(dice_table_entry, attrs)
  end
end
