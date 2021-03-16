defmodule Dsa.Type.SpellTradition do
  use Ecto.Type

  import DsaWeb.Gettext

  @traditions [
    %{
      id: :super,
      order: 0,
      title: gettext("SuperMagie"),
      short: gettext("Suer"),
      pages: "188-194",
      probe: "MU/GE/KK"
    },
    %{
      id: :mega,
      order: 1,
      title: gettext("MegaMagie"),
      short: gettext("Mega"),
      pages: "194-198",
      probe: "IN/CH/CH"
    },
    %{
      id: :ultra,
      order: 2,
      title: gettext("UltraMagie"),
      short: gettext("Ultra"),
      pages: "198-201",
      probe: "MU/GE/KO"
    }
  ]

  def type, do: :integer

  @doc """
  Converts a tradition atom into an index for efficient database storage
  """
  def cast(tradition) when is_binary(tradition) do
    tradition = String.to_atom(tradition)

    case Enum.find_index(@traditions, &(&1 == tradition)) do
      nil -> :error
      idx -> {:ok, idx}
    end
  end

  def cast(tradition) when tradition in @traditions do
    {:ok, Enum.find_index(@traditions, &(&1 == tradition))}
  end

  def cast(_), do: :error

  @doc """
  Converts a tradition index from database back into an atom (reverse of cast)
  """
  def load(data) do
    {:ok, Enum.at(@traditions, data)}
  end

  # at this point input category was converted to index so just check datatyp
  def dump(tradition) when is_integer(tradition), do: {:ok, tradition}

  def count, do: Enum.count(@traditions)
  def list, do: @traditions
end
