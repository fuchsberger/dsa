defmodule Dsa.Lore.MWeapon do
  use Ecto.Schema

  import Ecto.Changeset

  schema "mweapons" do
    field :name, :string
    field :tp_dice, :integer
    field :tp_bonus, :integer
    field :ge, :boolean
    field :kk, :boolean
    field :ls, :integer
    field :at_mod, :integer
    field :pa_mod, :integer
    field :rw, :integer
    belongs_to :combat_skill, Dsa.Lore.CombatSkill
  end

  @fields ~w(name tp_dice tp_bonus ge kk ls at_mod pa_mod rw combat_skill_id)a

  def changeset(weapon, attrs) do
    weapon
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> validate_length(:name, max: 25)
    |> validate_number(:tp_dice, greater_than_or_equal_to: 1, less_than_or_equal_to: 3)
    |> validate_number(:tp_dice, greater_than_or_equal_to: 0, less_than: 10)
    |> validate_number(:ls, greater_than_or_equal_to: 10)
    |> validate_number(:at_mod, greater_than_or_equal_to: -6, less_than_or_equal_to: 6)
    |> validate_number(:pa_mod, greater_than_or_equal_to: -6, less_than_or_equal_to: 6)
    |> validate_number(:rw, greater_than: 0, less_than_or_equal_to: 50)
    |> foreign_key_constraint(:combat_skill_id)
    |> unique_constraint(:name)
  end

  def entries do
    [
      {10, "Amazonensäbel", 1, 4, true, true, 15, 0, 0, 2},
      {14, "Anderthalbhänder", 1, 6, false, true, 14, 0, 0, 2},
      {10, "Barbarenschwert", 1, 5, true, true, 15, -1, -1, 2},
      {13, "Barbarenstreitaxt", 2, 4, false, true, 13, 0, -4, 2},
      {1, "Basiliskenzunge", 1, 2, true, false, 14, 0, -1, 1},
      {4, "Brabakbengel", 1, 5, false, true, 14, -1, -2, 2},
      {10, "Breitschwert", 1, 4, true, true, 14, -1, -1, 2},
      {1, "Dolch", 1, 1, true, false, 14, 0, 0, 2},
      {14, "Doppelkhunchomer", 2, 3, false, true, 14, 0, -2, 2},
      {1, "Drachenzahn", 1, 2, true, false, 14, 0, -1, 1},
      {12, "Dreizack", 1, 4, true, true, 15, 0, 0, 3},
      {12, "Dschadra", 1, 5, true, true, 15, 0, -1, 3},
      {10, "Entermesser", 1, 3, true, true, 15, 0, -1, 2},
      {9, "Faustschild", 1, 0, false, true, 16, -3, 0, 1},
      {13, "Felsspalter", 2, 2, false, true, 13, 0, -2, 2},
      {3, "Florett", 1, 3, true, false, 14, 1, 0, 2},
      {7, "Fuhrmannspeitsche", 1, 0, false, false, 16, 0, 0, 3},
      {12, "Glefe", 1, 5, true, true, 15, 0, -2, 3},
      {14, "Großer Sklaventod", 2, 3, false, true, 14, 0, -2, 2},
      {9, "Großschild", 1, 1, false, true, 16, -6, 3, 1},
      {1, "Hakendolch", 1, 1, true, false, 14, -1, 0, 1},
      {10, "Haumesser", 1, 3, true, true, 15, 0, -1, 2},
      {12, "Hellebarde", 1, 6, true, true, 15, 0, -2, 3},
      {9, "Holzschild", 1, 0, false, true, 16, -4, 1, 1},
      {12, "Holzspeer", 1, 2, true, true, 15, 0, 0, 3},
      {1, "Jagdmesser", 1, 1, true, false, 14, 0, -2, 1},
      {12, "Jagdspieß", 1, 5, true, true, 15, 0, -1, 3},
      {12, "Kampfstab", 1, 1, true, true, 15, 0, 2, 3},
      {1, "Katar", 1, 1, true, false, 13, 0, -1, 1},
      {4, "Keule", 1, 3, false, true, 14, 0, -1, 2},
      {10, "Khunchomer", 1, 4, true, true, 15, 0, 0, 2},
      {4, "Knüppel", 1, 2, false, true, 14, 0, -2, 2},
      {13, "Kriegshammer", 2, 3, false, true, 13, 0, -3, 2},
      {10, "Kurzschwert", 1, 2, true, true, 15, 0, 0, 1},
      {10, "Langschwert", 1, 4, true, true, 15, 0, 0, 2},
      {9, "Lederschild", 1, 0, false, true, 16, -4, 1, 1},
      {4, "Lindwurmschläger", 1, 4, false, true, 14, 0, -1, 1},
      {1, "Linkhand", 1, 1, true, false, 14, 0, 0, 1},
      {4, "Magierstab (Kurz)", 1, 1, false, true, 14, 0, -1, 1},
      {4, "Magierstab (Mittel)", 1, 2, false, true, 14, 0, -1, 2},
      {12, "Magierstab (Lang)", 1, 2, true, true, 16, -1, 2, 3},
      {1, "Mengbilar", 1, 1, true, false, 14, 0, -2, 1},
      {1, "Messer", 1, 1, true, false, 14, 0, -2, 1},
      {4, "Molokdeschnaja", 1, 4, false, true, 14, 0, -1, 2},
      {5, "Morgenstern", 1, 5, false, true, 14, 0, 0, 2},
      {10, "Nachtwind", 1, 4, true, true, 15, 0, 0, 2},
      {5, "Ochsenherde", 2, 6, false, true, 14, -2, 0, 2},
      {1, "Ogerfänger", 1, 2, true, false, 14, 0, -1, 1},
      {5, "Ogerschelle", 2, 2, false, true, 14, -2, 0, 2},
      {8, "Orchidee", 1, 2, true, true, 15, 0, -1, 1},
      {4, "Orknase", 1, 5, false, true, 14, -1, -2, 2},
      {8, "Panzerarm", 1, 1, true, true, 15, 0, 0, 1},
      {4, "Rabenschnabel", 1, 4, false, true, 14, 0, -2, 2},
      {3, "Rapier", 1, 3, true, false, 15, 1, 1, 2},
      {14, "Richtschwert", 2, 6, false, true, 14, -2, -3, 2},
      {10, "Robbentöter", 1, 4, true, true, 15, 0, 0, 2},
      {14, "Rondrakamm", 2, 2, false, true, 14, 0, -1, 2},
      {10, "Säbel", 1, 3, true, true, 15, 0, 0, 2},
      {8, "Schlagring", 1, 1, true, true, 15, 0, 0, 1},
      {12, "Schnitter", 1, 5, true, true, 15, -1, -1, 3},
      {1, "Schwerer Dolch", 1, 2, true, false, 14, 0, -1, 1},
      {10, "Sklaventod", 1, 4, true, true, 15, 0, 0, 2},
      {4, "Sonnenzepter", 1, 3, false, true, 14, 0, -1, 2},
      {12, "Speer", 1, 4, true, true, 15, 0, 0, 3},
      {3, "Stockdegen", 1, 2, true, false, 15, 1, 0, 2},
      {4, "Streitaxt", 1, 4, false, true, 14, 0, -1, 2},
      {4, "Streitkolben", 1, 4, false, true, 14, 0, -1, 2},
      {9, "Thorwalerschild", 1, 1, false, true, 16, -5, 2, 1},
      {14, "Tuzakmesser", 1, 6, false, true, 14, 0, 0, 2},
      {1, "Waqqif", 1, 2, true, false, 14, 0, -1, 1},
      {13, "Warunker Hammer", 1, 6, false, true, 14, 0, -3, 2},
      {3, "Wolfsmesser", 1, 4, true, false, 15, 1, 0, 2},
      {14, "Zweihänder", 2, 4, false, true, 14, 0, -3, 2},
      {12, "Zweililie", 1, 4, true, true, 15, 0, 2, 2},
      {13, "Zwergenschlägel", 1, 6, false, true, 13, 0, -1, 2}
    ]
    |> Enum.map(fn {combat_skill_id, name, tp_dice, tp_bonus, ge, kk, ls, at_mod, pa_mod, rw} ->
      %{
        name: name,
        combat_skill_id: combat_skill_id,
        tp_dice: tp_dice,
        tp_bonus: tp_bonus,
        ge: ge, kk: kk, ls: ls,
        at_mod: at_mod,
        pa_mod: pa_mod,
        rw: rw
      }
    end)
  end
end
