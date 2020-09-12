defmodule Dsa.Data do
  use GenServer
  require Logger

  @name __MODULE__

  @traditions [
    {1, nil, nil, "Allgemein", nil},
    # Zauberertraditionen
    {2, true, "KL", "Gildenmagier", 155},
    {3, true, "IN", "Elf", 125},
    {4, true, "CH", "Hexe", 135},
    # Geweihtentraditionen
    {5, false, "MU", "Boronkirche", 130},
    {6, false, "KL", "Hesindekirche", 130},
    {7, false, "IN", "Perainekirche", 110},
    {8, false, "IN", "Phexkirche", 150},
    {9, false, "KL", "Praioskirche", 130},
    {10, false, "MU", "Rondrakirche", 150}
  ]

  def start_link(_), do: GenServer.start_link(__MODULE__, [], name: @name)

  def init(_) do
    Logger.debug("Creating Lore In-Memory Database...")
    :ets.new(:traditions, [:ordered_set, :protected, :named_table])
    :ets.insert(:traditions, @traditions)
    {:ok, "ETS Created"}
  end

  def traditions, do: :ets.tab2list(:traditions)

  def tradition(id) do
    case :ets.lookup(:traditions, id) do
      [] -> nil
      [data] -> data
    end
  end

  def tradition(nil, _), do: nil
  def tradition(id, :ap), do: :ets.lookup_element(:traditions, id, 5)
  def tradition(id, :le), do: :ets.lookup_element(:traditions, id, 3)
  def tradition(id, :name), do: :ets.lookup_element(:traditions, id, 4)

  def tradition_options(:magic) do
    traditions()
    |> Enum.filter(fn {_id, magic, _le, _name, _ap} -> magic end)
    |> Enum.map(fn {id, _magic, _le, name, _ap} -> {name, id} end)
  end

  def tradition_options(:karmal) do
    traditions()
    |> Enum.filter(fn {_id, magic, _le, _name, _ap} -> magic == false end)
    |> Enum.map(fn {id, _magic, _le, name, _ap} -> {name, id} end)
  end
end
