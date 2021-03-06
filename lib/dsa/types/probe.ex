defmodule Dsa.Type.Probe do
  use Ecto.Type

  @traits ~w(mu kl in ch ff ge ko kk)a

  def type, do: :integer
  require Logger
  @doc """
  Converts a tuple of three traits into an integer (reversible)
  """
  def cast({t1, t2, t3} = t) when t1 in @traits and t2 in @traits and t3 in @traits do

    n1 = Enum.find_index(@traits, & &1 == t1) * 64
    n2 = Enum.find_index(@traits, & &1 == t2) * 8
    n3 = Enum.find_index(@traits, & &1 == t2)

    {:ok, n1 + n2 + n3}
  end

  def cast(_), do: :error

  @doc """
  Converts data from database back into a tuple of three traits (reverse of cast)
  """
  def load(data) do
    {n1, data} = {div(data, 64), rem(data, 64)}
    {n2, n3} = {div(data, 8), rem(data, 8)}

    {:ok, {Enum.at(@traits, n1), Enum.at(@traits, n2), Enum.at(@traits, n3)}}
  end

  def dump(probe), do: {:ok, probe}

  def list_traits, do: @traits
end
