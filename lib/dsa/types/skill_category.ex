defmodule Dsa.Type.SkillCategory do
  use Ecto.Type

  @categories ~w(body social nature knowledge crafting)a

  def type, do: :integer

  @doc """
  Converts a category atom into an index for efficient database storage
  """
  def cast(category) when category in @categories do
    {:ok, Enum.find_index(@categories, & &1 == category)}
  end

  def cast(_), do: :error

  @doc """
  Converts a category index from database back into an atom (reverse of cast)
  """
  def load(data) do
    {:ok, Enum.at(@categories, data)}
  end

  # at this point input category was converted to index so just check datatyp
  def dump(category) when is_integer(category), do: {:ok, category}

  def count, do: Enum.count(@categories)
  def list, do: @categories
end
