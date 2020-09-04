defmodule Dsa.Lore.CombatSkill do
  use Ecto.Schema

  import Ecto.Changeset
  import Dsa.Lists

  schema "combat_skills" do
    field :name, :string
    field :ranged, :boolean
    field :parade, :boolean
    field :bf, :integer
    field :e1, :string
    field :e2, :string
    field :sf, :string

    has_many :mweapons, Dsa.Lore.MWeapon
    has_many :fweapons, Dsa.Lore.FWeapon

    many_to_many :special_skills, Dsa.Lore.SpecialSkill,
      join_through: "combat_special_skills",
      on_replace: :delete

    many_to_many :characters, Dsa.Accounts.Character,
      join_through: Dsa.Accounts.CharacterCombatSkill,
      on_replace: :delete
  end

  @fields ~w(id name ranged bf parade e1 e2 sf)a
  @reqired ~w(id name ranged bf parade e1 sf)a
  def changeset(skill, attrs) do
    skill
    |> cast(attrs, @fields)
    |> validate_required(@reqired)
    |> validate_inclusion(:e1, base_value_options())
    |> validate_inclusion(:e2, base_value_options())
    |> validate_inclusion(:sf, sf_values())
  end

  def entries do
    [
      # Close combat
      { 1, "B", false, true, "GE", "Dolche", 14, nil },
      { 2, "C", false, true, "GE", "Fächer", 13, nil },
      { 3, "C", false, true, "GE", "Fechtwaffen", 8, nil },
      { 4, "C", false, true, "KK", "Hiebwaffen", 12, nil },
      { 5, "C", false, false, "KK", "Kettenwaffen", 10, nil },
      { 6, "B", false, true, "KK", "Lanzen", 6, nil },
      { 7, "B", false, false, "FF", "Peitschen", 4, nil },
      { 8, "B", false, true, "GE", "Raufen", 12, "KK" },
      { 9, "C", false, true, "KK", "Schilde", 10, nil },
      { 10, "C", false, true, "GE", "Schwerter", 13, "KK" },
      { 11, "C", false, false, "KK", "Spießwaffen", 12, nil },
      { 12, "C", false, true, "GE", "Stangenwaffen", 12, "KK" },
      { 13, "C", false, true, "KK", "Zweihandhiebwaffen", 11, nil },
      { 14, "C", false, true, "KK", "Zweihandschwerter", 12, nil },
      # Ranged combat
      { 15, "B", true, false, "FF", "Armbrüste", 6, nil },
      { 16, "B", true, false, "FF", "Blasrohre", 10, nil },
      { 17, "C", true, false, "FF", "Bögen", 4, nil },
      { 18, "C", true, false, "FF", "Diskusse", 12, nil },
      { 19, "B", true, false, "FF", "Feuerspeien", 20, nil },
      { 20, "B", true, false, "FF", "Schleudern", 4, nil },
      { 21, "B", true, false, "FF", "Wurfwaffen", 10, nil }
    ]
    |> Enum.map(fn {id, sf, ranged, parade, e1, name, bf, e2} -> %{
        id: id,
        name: name,
        ranged: ranged,
        parade: parade,
        bf: bf,
        e1: e1,
        e2: e2,
        sf: sf
      } end)
  end
end
