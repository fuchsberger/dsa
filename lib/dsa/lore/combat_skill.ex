defmodule Dsa.Lore.CombatSkill do
  use Ecto.Schema

  import Ecto.Changeset
  import Dsa.Lists

  schema "combat_skills" do
    field :name, :string
    field :ranged, :boolean
    field :parade, :boolean
    field :bf, :integer
    field :ge, :boolean, default: false
    field :kk, :boolean, default: false
    field :sf, :string

    has_many :mweapons, Dsa.Lore.MWeapon
    has_many :fweapons, Dsa.Lore.FWeapon

    many_to_many :characters, Dsa.Accounts.Character,
      join_through: Dsa.Accounts.CharacterCombatSkill,
      on_replace: :delete
  end

  @fields ~w(name ranged bf parade ge kk sf)a
  def changeset(skill, attrs) do
    skill
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> validate_inclusion(:sf, sf_values())
  end

  def entries do
    [
      # Close combat
      {"B", false, true, true, false, "Dolche", 14 },
      {"C", false, true, true, false, "Fächer", 13 },
      {"C", false, true, true, false, "Fechtwaffen", 8 },
      {"C", false, true, false, true, "Hiebwaffen", 12 },
      {"C", false, false, false, true, "Kettenwaffen", 10 },
      {"B", false, true, false, true, "Lanzen", 6 },
      {"B", false, false, false, false, "Peitschen", 4 },
      {"B", false, true, true, true, "Raufen", 12 },
      {"C", false, true, false, true, "Schilde", 10 },
      {"C", false, true, true, true, "Schwerter", 13 },
      {"C", false, false, false, true, "Spießwaffen", 12 },
      {"C", false, true, true, true, "Stangenwaffen", 12 },
      {"C", false, true, false, true, "Zweihandhiebwaffen", 11 },
      {"C", false, true, false, true, "Zweihandschwerter", 12 },
      # Ranged combat
      {"B", true, false, false, false, "Armbrüste", 6 },
      {"B", true, false, false, false, "Blasrohre", 10 },
      {"C", true, false, false, false, "Bögen", 4 },
      {"C", true, false, false, false, "Diskusse", 12 },
      {"B", true, false, false, false, "Feuerspeien", 20 },
      {"B", true, false, false, false, "Schleudern", 4 },
      {"B", true, false, false, false, "Wurfwaffen", 10 }
    ]
    |> Enum.map(fn {sf, ranged, parade, ge, kk, name, bf} -> %{
        name: name,
        ranged: ranged,
        parade: parade,
        bf: bf,
        ge: ge,
        kk: kk,
        sf: sf
      } end)
  end
end
