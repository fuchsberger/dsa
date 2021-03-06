defmodule Dsa.Data.MWeapon do
  @moduledoc """
  CharacterArmor module
  """
  use Ecto.Schema
  use Phoenix.HTML
  import Ecto.Changeset

  @table :mweapons

  @primary_key false
  schema "mweapons" do
    field :dmg, :integer, default: 0
    field :id, :integer, primary_key: true
    belongs_to :character, Dsa.Characters.Character, primary_key: true
  end

  @fields ~w(character_id id dmg)a
  def changeset(mweapon, params \\ %{}) do
    mweapon
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_number(:dmg, greater_than_or_equal_to: 0, less_than_or_equal_to: 4)
    |> validate_number(:id, greater_than: 0, less_than_or_equal_to: count())
    |> foreign_key_constraint(:character_id)
    |> unique_constraint([:character_id, :id])
  end

  def count, do: 75
  def list, do: :ets.tab2list(@table)
  def get(id), do: List.first(:ets.lookup(@table, id))

  def options(c) do
    character_ids = Enum.map(c.fweapons, & &1.id)
    1..count()
    |> Enum.reject(& Enum.member?(character_ids, &1))
    |> Enum.map(& {name(&1), &1})
  end

  def combat_skill(id), do: :ets.lookup_element(@table, id, 2)
  def name(id), do: :ets.lookup_element(@table, id, 3)
  def tp_dice(id), do: :ets.lookup_element(@table, id, 4)
  def tp_bonus(id), do: :ets.lookup_element(@table, id, 5)
  def ge(id), do: :ets.lookup_element(@table, id, 6)
  def kk(id), do: :ets.lookup_element(@table, id, 7)
  def ls(id), do: :ets.lookup_element(@table, id, 8)
  def at_mod(id), do: :ets.lookup_element(@table, id, 9)
  def pa_mod(id), do: :ets.lookup_element(@table, id, 10)
  def rw(id), do: :ets.lookup_element(@table, id, 11)

  def tooltip(_id) do
    ~E"""
    <p class="small mb-1">TODO</p>
    """
  end

  def seed do
    :ets.new(@table , [:ordered_set, :protected, :named_table])
    :ets.insert(@table, [
      # {id, combat_skill_id, name, tp_dice, tp_bonus, ge, kk, ls, at_mod, pa_mod, rw}
      {1, 10, "Amazonensäbel", 1, 4, true, true, 15, 0, 0, 2},
      {2, 14, "Anderthalbhänder", 1, 6, false, true, 14, 0, 0, 2},
      {3, 10, "Barbarenschwert", 1, 5, true, true, 15, -1, -1, 2},
      {4, 13, "Barbarenstreitaxt", 2, 4, false, true, 13, 0, -4, 2},
      {5, 1, "Basiliskenzunge", 1, 2, true, false, 14, 0, -1, 1},
      {6, 4, "Brabakbengel", 1, 5, false, true, 14, -1, -2, 2},
      {7, 10, "Breitschwert", 1, 4, true, true, 14, -1, -1, 2},
      {8, 1, "Dolch", 1, 1, true, false, 14, 0, 0, 2},
      {9, 14, "Doppelkhunchomer", 2, 3, false, true, 14, 0, -2, 2},
      {10, 1, "Drachenzahn", 1, 2, true, false, 14, 0, -1, 1},
      {11, 12, "Dreizack", 1, 4, true, true, 15, 0, 0, 3},
      {12, 12, "Dschadra", 1, 5, true, true, 15, 0, -1, 3},
      {13, 10, "Entermesser", 1, 3, true, true, 15, 0, -1, 2},
      {14, 9, "Faustschild", 1, 0, false, true, 16, -3, 0, 1},
      {15, 13, "Felsspalter", 2, 2, false, true, 13, 0, -2, 2},
      {16, 3, "Florett", 1, 3, true, false, 14, 1, 0, 2},
      {17, 7, "Fuhrmannspeitsche", 1, 0, false, false, 16, 0, 0, 3},
      {18, 12, "Glefe", 1, 5, true, true, 15, 0, -2, 3},
      {19, 14, "Großer Sklaventod", 2, 3, false, true, 14, 0, -2, 2},
      {20, 9, "Großschild", 1, 1, false, true, 16, -6, 3, 1},
      {21, 1, "Hakendolch", 1, 1, true, false, 14, -1, 0, 1},
      {22, 10, "Haumesser", 1, 3, true, true, 15, 0, -1, 2},
      {23, 12, "Hellebarde", 1, 6, true, true, 15, 0, -2, 3},
      {24, 9, "Holzschild", 1, 0, false, true, 16, -4, 1, 1},
      {25, 12, "Holzspeer", 1, 2, true, true, 15, 0, 0, 3},
      {26, 1, "Jagdmesser", 1, 1, true, false, 14, 0, -2, 1},
      {27, 12, "Jagdspieß", 1, 5, true, true, 15, 0, -1, 3},
      {28, 12, "Kampfstab", 1, 1, true, true, 15, 0, 2, 3},
      {29, 1, "Katar", 1, 1, true, false, 13, 0, -1, 1},
      {30, 4, "Keule", 1, 3, false, true, 14, 0, -1, 2},
      {31, 10, "Khunchomer", 1, 4, true, true, 15, 0, 0, 2},
      {32, 4, "Knüppel", 1, 2, false, true, 14, 0, -2, 2},
      {33, 13, "Kriegshammer", 2, 3, false, true, 13, 0, -3, 2},
      {34, 10, "Kurzschwert", 1, 2, true, true, 15, 0, 0, 1},
      {35, 10, "Langschwert", 1, 4, true, true, 15, 0, 0, 2},
      {36, 9, "Lederschild", 1, 0, false, true, 16, -4, 1, 1},
      {37, 4, "Lindwurmschläger", 1, 4, false, true, 14, 0, -1, 1},
      {38, 1, "Linkhand", 1, 1, true, false, 14, 0, 0, 1},
      {39, 4, "Magierstab (Kurz)", 1, 1, false, true, 14, 0, -1, 1},
      {40, 4, "Magierstab (Mittel)", 1, 2, false, true, 14, 0, -1, 2},
      {41, 12, "Magierstab (Lang)", 1, 2, true, true, 16, -1, 2, 3},
      {42, 1, "Mengbilar", 1, 1, true, false, 14, 0, -2, 1},
      {43, 1, "Messer", 1, 1, true, false, 14, 0, -2, 1},
      {44, 4, "Molokdeschnaja", 1, 4, false, true, 14, 0, -1, 2},
      {45, 5, "Morgenstern", 1, 5, false, true, 14, 0, 0, 2},
      {46, 10, "Nachtwind", 1, 4, true, true, 15, 0, 0, 2},
      {47, 5, "Ochsenherde", 2, 6, false, true, 14, -2, 0, 2},
      {48, 1, "Ogerfänger", 1, 2, true, false, 14, 0, -1, 1},
      {49, 5, "Ogerschelle", 2, 2, false, true, 14, -2, 0, 2},
      {50, 8, "Orchidee", 1, 2, true, true, 15, 0, -1, 1},
      {51, 4, "Orknase", 1, 5, false, true, 14, -1, -2, 2},
      {52, 8, "Panzerarm", 1, 1, true, true, 15, 0, 0, 1},
      {53, 4, "Rabenschnabel", 1, 4, false, true, 14, 0, -2, 2},
      {54, 3, "Rapier", 1, 3, true, false, 15, 1, 1, 2},
      {55, 14, "Richtschwert", 2, 6, false, true, 14, -2, -3, 2},
      {56, 10, "Robbentöter", 1, 4, true, true, 15, 0, 0, 2},
      {57, 14, "Rondrakamm", 2, 2, false, true, 14, 0, -1, 2},
      {58, 10, "Säbel", 1, 3, true, true, 15, 0, 0, 2},
      {59, 8, "Schlagring", 1, 1, true, true, 15, 0, 0, 1},
      {60, 12, "Schnitter", 1, 5, true, true, 15, -1, -1, 3},
      {61, 1, "Schwerer Dolch", 1, 2, true, false, 14, 0, -1, 1},
      {62, 10, "Sklaventod", 1, 4, true, true, 15, 0, 0, 2},
      {63, 4, "Sonnenzepter", 1, 3, false, true, 14, 0, -1, 2},
      {64, 12, "Speer", 1, 4, true, true, 15, 0, 0, 3},
      {65, 3, "Stockdegen", 1, 2, true, false, 15, 1, 0, 2},
      {66, 4, "Streitaxt", 1, 4, false, true, 14, 0, -1, 2},
      {67, 4, "Streitkolben", 1, 4, false, true, 14, 0, -1, 2},
      {68, 9, "Thorwalerschild", 1, 1, false, true, 16, -5, 2, 1},
      {69, 14, "Tuzakmesser", 1, 6, false, true, 14, 0, 0, 2},
      {70, 1, "Waqqif", 1, 2, true, false, 14, 0, -1, 1},
      {71, 13, "Warunker Hammer", 1, 6, false, true, 14, 0, -3, 2},
      {72, 3, "Wolfsmesser", 1, 4, true, false, 15, 1, 0, 2},
      {73, 14, "Zweihänder", 2, 4, false, true, 14, 0, -3, 2},
      {74, 12, "Zweililie", 1, 4, true, true, 15, 0, 2, 2},
      {75, 13, "Zwergenschlägel", 1, 6, false, true, 13, 0, -1, 2}
    ])
  end
end
