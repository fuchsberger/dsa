defmodule Dsa.Lore.MWeapon do
  use Ecto.Schema

  import Ecto.Changeset
  import Dsa.Lists

  schema "mweapons" do
    field :name, :string
    field :tp_dice, :integer
    field :tp_bonus, :integer
    field :l1, :string
    field :l2, :string
    field :ls, :integer
    field :at_mod, :integer
    field :pa_mod, :integer
    field :rw, :integer
    belongs_to :combat_skill, Dsa.Lore.CombatSkill
  end

  @fields ~w(id name tp_dice tp_bonus l1 ls at_mod pa_mod rw combat_skill_id)a

  def changeset(weapon, attrs) do
    weapon
    |> cast(attrs, [:l2 | @fields])
    |> validate_required(@fields)
    |> validate_length(:name, max: 25)
    |> validate_number(:tp_dice, greater_than_or_equal_to: 1, less_than_or_equal_to: 3)
    |> validate_number(:tp_dice, greater_than_or_equal_to: 0, less_than: 10)
    |> validate_inclusion(:l1, base_value_options())
    |> validate_inclusion(:l2, base_value_options())
    |> validate_number(:ls, greater_than_or_equal_to: 10)
    |> validate_number(:at_mod, greater_than_or_equal_to: -6, less_than_or_equal_to: 6)
    |> validate_number(:pa_mod, greater_than_or_equal_to: -6, less_than_or_equal_to: 6)
    |> validate_number(:rw, greater_than: 0, less_than_or_equal_to: 50)
    |> foreign_key_constraint(:combat_skill_id)
  end

  def entries do
    [
      {1, 10, "Amazonensäbel", 1, 4, "GE", "KK", 15, 0, 0, 2},
      {2, 14, "Anderthalbhänder", 1, 6, "KK", nil, 14, 0, 0, 2},
      {3, 10, "Barbarenschwert", 1, 5, "GE", "KK", 15, -1, -1, 2},
      {4, 13, "Barbarenstreitaxt", 2, 4, "KK", nil, 13, 0, -4, 2},
      {5, 1, "Basiliskenzunge", 1, 2, "GE", nil, 14, 0, -1, 1},
      {6, 4, "Brabakbengel", 1, 5, "KK", nil, 14, -1, -2, 2},
      {7, 10, "Breitschwert", 1, 4, "GE", "KK", 14, -1, -1, 2},
      {8, 1, "Dolch", 1, 1, "GE", nil, 14, 0, 0, 2},
      {9, 14, "Doppelkhunchomer", 2, 3, "KK", nil, 14, 0, -2, 2},
      {10, 1, "Drachenzahn", 1, 2, "GE", nil, 14, 0, -1, 1},
      {11, 12, "Dreizack", 1, 4, "GE", "KK", 15, 0, 0, 3},
      {12, 12, "Dschadra", 1, 5, "GE", "KK", 15, 0, -1, 3},
      {13, 10, "Entermesser", 1, 3, "GE", "KK", 15, 0, -1, 2},
      {14, 9, "Faustschild", 1, 0, "KK", nil, 16, -3, 0, 1},
      {15, 13, "Felsspalter", 2, 2, "KK", nil, 13, 0, -2, 2},
      {16, 3, "Florett", 1, 3, "GE", nil, 14, 1, 0, 2},
      {17, 7, "Fuhrmannspeitsche", 1, 0, "FF", nil, 16, 0, 0, 3},
      {18, 12, "Glefe", 1, 5, "GE", "KK", 15, 0, -2, 3},
      {19, 14, "Großer Sklaventod", 2, 3, "KK", nil, 14, 0, -2, 2},
      {20, 9, "Großschild", 1, 1, "KK", nil, 16, -6, 3, 1},
      {21, 1, "Hakendolch", 1, 1, "GE", nil, 14, -1, 0, 1},
      {22, 10, "Haumesser", 1, 3, "GE", "KK", 15, 0, -1, 2},
      {23, 12, "Hellebarde", 1, 6, "GE", "KK", 15, 0, -2, 3},
      {24, 9, "Holzschild", 1, 0, "KK", nil, 16, -4, 1, 1},
      {25, 12, "Holzspeer", 1, 2, "GE", "KK", 15, 0, 0, 3},
      {26, 1, "Jagdmesser", 1, 1, "GE", nil, 14, 0, -2, 1},
      {27, 12, "Jagdspieß", 1, 5, "GE", "KK", 15, 0, -1, 3},
      {28, 12, "Kampfstab", 1, 1, "GE", "KK", 15, 0, 2, 3},
      {29, 1, "Katar", 1, 1, "GE", nil, 13, 0, -1, 1},
      {30, 4, "Keule", 1, 3, "KK", nil, 14, 0, -1, 2},
      {31, 10, "Khunchomer", 1, 4, "GE", "KK", 15, 0, 0, 2},
      {32, 4, "Knüppel", 1, 2, "KK", nil, 14, 0, -2, 2},
      {33, 13, "Kriegshammer", 2, 3, "KK", nil, 13, 0, -3, 2},
      {34, 10, "Kurzschwert", 1, 2, "GE", "KK", 15, 0, 0, 1},
      {35, 10, "Langschwert", 1, 4, "GE", "KK", 15, 0, 0, 2},
      {36, 9, "Lederschild", 1, 0, "KK", nil, 16, -4, 1, 1},
      {37, 4, "Lindwurmschläger", 1, 4, "KK", nil, 14, 0, -1, 1},
      {38, 1, "Linkhand", 1, 1, "GE", nil, 14, 0, 0, 1},
      {39, 4, "Magierstab (Kurz)", 1, 1, "KK", nil, 14, 0, -1, 1},
      {40, 4, "Magierstab (Mittel)", 1, 2, "KK", nil, 14, 0, -1, 2},
      {41, 12, "Magierstab (Lang)", 1, 2, "GE", "KK", 16, -1, 2, 3},
      {42, 1, "Mengbilar", 1, 1, "GE", nil, 14, 0, -2, 1},
      {43, 1, "Messer", 1, 1, "GE", nil, 14, 0, -2, 1},
      {44, 4, "Molokdeschnaja", 1, 4, "KK", nil, 14, 0, -1, 2},
      {45, 5, "Morgenstern", 1, 5, "KK", nil, 14, 0, 0, 2},
      {46, 10, "Nachtwind", 1, 4, "GE", "KK", 15, 0, 0, 2},
      {47, 5, "Ochsenherde", 2, 6, "KK", nil, 14, -2, 0, 2},
      {48, 1, "Ogerfänger", 1, 2, "GE", nil, 14, 0, -1, 1},
      {49, 5, "Ogerschelle", 2, 2, "KK", nil, 14, -2, 0, 2},
      {50, 8, "Orchidee", 1, 2, "GE", "KK", 15, 0, -1, 1},
      {51, 4, "Orknase", 1, 5, "KK", nil, 14, -1, -2, 2},
      {52, 8, "Panzerarm", 1, 1, "GE", "KK", 15, 0, 0, 1},
      {53, 4, "Rabenschnabel", 1, 4, "KK", nil, 14, 0, -2, 2},
      {54, 3, "Rapier", 1, 3, "GE", nil, 15, 1, 1, 2},
      {55, 14, "Richtschwert", 2, 6, "KK", nil, 14, -2, -3, 2},
      {56, 10, "Robbentöter", 1, 4, "GE", "KK", 15, 0, 0, 2},
      {57, 14, "Rondrakamm", 2, 2, "KK", nil, 14, 0, -1, 2},
      {58, 10, "Säbel", 1, 3, "GE", "KK", 15, 0, 0, 2},
      {59, 8, "Schlagring", 1, 1, "GE", "KK", 15, 0, 0, 1},
      {60, 12, "Schnitter", 1, 5, "GE", "KK", 15, -1, -1, 3},
      {61, 1, "Schwerer Dolch", 1, 2, "GE", nil, 14, 0, -1, 1},
      {62, 10, "Sklaventod", 1, 4, "GE", "KK", 15, 0, 0, 2},
      {63, 4, "Sonnenzepter", 1, 3, "KK", nil, 14, 0, -1, 2},
      {64, 12, "Speer", 1, 4, "GE", "KK", 15, 0, 0, 3},
      {65, 3, "Stockdegen", 1, 2, "GE", nil, 15, 1, 0, 2},
      {66, 4, "Streitaxt", 1, 4, "KK", nil, 14, 0, -1, 2},
      {67, 4, "Streitkolben", 1, 4, "KK", nil, 14, 0, -1, 2},
      {68, 9, "Thorwalerschild", 1, 1, "KK", nil, 16, -5, 2, 1},
      {69, 14, "Tuzakmesser", 1, 6, "KK", nil, 14, 0, 0, 2},
      {70, 1, "Waqqif", 1, 2, "GE", nil, 14, 0, -1, 1},
      {71, 13, "Warunker Hammer", 1, 6, "KK", nil, 14, 0, -3, 2},
      {72, 3, "Wolfsmesser", 1, 4, "GE", nil, 15, 1, 0, 2},
      {73, 14, "Zweihänder", 2, 4, "KK", nil, 14, 0, -3, 2},
      {74, 12, "Zweililie", 1, 4, "GE", "KK", 15, 0, 2, 2},
      {75, 13, "Zwergenschlägel", 1, 6, "KK", nil, 13, 0, -1, 2}
    ]
    |> Enum.map(fn {id, combat_skill_id, name, tp_dice, tp_bonus, l1, l2, ls, at_mod, pa_mod, rw} ->
      %{
        id: id,
        name: name,
        combat_skill_id: combat_skill_id,
        tp_dice: tp_dice,
        tp_bonus: tp_bonus,
        l1: l1, l2: l2, ls: ls,
        at_mod: at_mod,
        pa_mod: pa_mod,
        rw: rw
      }
    end)
  end
end
