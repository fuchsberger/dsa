defmodule Dsa.Type.Probe do
  use Ecto.Type

  import DsaWeb.DsaHelpers, only: [traits: 0]

  def type, do: :integer

  require Logger

  @doc """
  Converts a tuple of three traits into an integer (reversible)
  """
  def cast({t1, t2, t3}) do
    traits = traits()
    n1 = Enum.find_index(traits, & &1 == t1) * 64
    n2 = Enum.find_index(traits, & &1 == t2) * 8
    n3 = Enum.find_index(traits, & &1 == t3)
    {:ok, n1 + n2 + n3}
  end

  def cast(_), do: :error

  @doc """
  Converts data from database back into a tuple of three traits (reverse of cast)
  """
  def load(data) do
    traits = traits()
    {n1, data} = {div(data, 64), rem(data, 64)}
    {n2, n3} = {div(data, 8), rem(data, 8)}

    {:ok, {Enum.at(traits, n1), Enum.at(traits, n2), Enum.at(traits, n3)}}
  end

  def dump({t1, t2, t3}), do: cast({t1, t2, t3})

  def dump(_), do: :error
end
