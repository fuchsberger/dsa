defmodule Dsa.Type.SkillCategory do
  @moduledoc """
  Compresses a category string (example: "Handwerkstalente") for efficient database storage.
  On retrival converts to atom. (example: :crafting)
  """
  use Ecto.Type

  @categories ~w(physical social nature knowledge crafting)a

  def type, do: :integer

  @doc """
  Converts a german category name into an integer for efficient data storage.
  """
  def cast(category) when is_binary(category) do
    case category do
      "Körpertalente" -> {:ok, :physical}
      "Gesellschaftstalente" -> {:ok, :social}
      "Naturtalente" -> {:ok, :nature}
      "Wissenstalente" -> {:ok, :knowledge}
      "Handwerkstalente" -> {:ok, :crafting}
      _ -> :error
    end
  end

  def cast(_), do: :error

  @doc """
  Converts a category index from database back into an atom.
  """
  def load(index), do: {:ok, Enum.at(@categories, index)}

  @doc """
  Allows dumping data to database if the value produced by cast is an integer.
  """
  def dump(category) when is_atom(category) do
    {:ok, Enum.find_index(@categories, & &1 == category)}
  end

  def dump(_), do: :error

  def values, do: @categories

  # TODO: Recycle

  # def list_types, do: Enum.map(@categories, & &1.id)

  # def get(id, invalid_return \\ nil), do: Enum.find(@categories, invalid_return, & &1.id == id)

  # def options, do: Enum.map(@categories, & {&1.short, &1.id})

  # def count, do: Enum.count(@categories)
end
