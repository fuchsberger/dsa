defmodule Dsa.Type.Reference do
  @moduledoc """
  Compresses a book / page (example: {"Basis Regelwerk", 206}) for efficient database storage.
  On retrival converts back to tuple.
  """
  use Ecto.Type

  @factors ~w(a b c d e)a

  def type, do: :integer

  @doc """
  Converts a cost factor string into an integer for efficient data storage.
  """
  def cast(factor) when is_binary(factor) do
    case factor do
      "A" -> {:ok, :a}
      "B" -> {:ok, :b}
      "C" -> {:ok, :c}
      "D" -> {:ok, :d}
      "E" -> {:ok, :e}
      _ -> :error
    end
  end

  def cast(_), do: :error

  @doc """
  Converts a factor index from database back into an atom.
  """
  def load(index), do: {:ok, Enum.at(@factors, index)}

  @doc """
  Allows dumping data to database if the value produced by cast is an integer.
  """
  def dump(factor) when is_atom(factor) do
    {:ok, Enum.find_index(@factors, & &1 == factor)}
  end

  def dump(_), do: :error

  def values, do: @factors
end
