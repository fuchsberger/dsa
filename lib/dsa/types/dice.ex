defmodule Dsa.Type.Dice do
  @moduledoc """
  Special Type that allows to store 3 D20 in a single integer
  Each D20 can go to 20 -> 5 bits are needed. Thus 3 dice fit in a smallint variable (3*5 <= 16)
  """
  use Ecto.Type

  def type, do: :integer

  @doc """
  Converts a tuple of three dice rolls (up to 32) into a single integer (reversible)
  """
  def cast({d1, d2, d3}) when d1 <= 32 and d2 <= 32 and d3 <= 32 do
    {:ok, d3*1024 + d2*32 + d1}
  end

  def cast(_), do: :error

  @doc """
  Converts data from database back into a tuple of three dice (reverse of cast)
  """
  def load(data) do
    {d3, data} = {div(data, 1024), rem(data, 1024)}
    {d2, d1} = {div(data, 32), rem(data, 32)}
    {:ok, {d1, d2, d3}}
  end

  def dump({d1, d2, d3}), do: cast({d1, d2, d3})

  def dump(_), do: :error
end
