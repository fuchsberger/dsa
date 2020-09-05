defmodule Dsa.Lore.FWeapon do
  use Ecto.Schema

  import Ecto.Changeset

  schema "fweapons" do
    field :name, :string
    field :tp_dice, :integer
    field :tp_bonus, :integer
    field :rw1, :integer
    field :rw2, :integer
    field :rw3, :integer
    field :lz, :integer
    belongs_to :combat_skill, Dsa.Lore.CombatSkill
  end

  @fields ~w(name tp_dice tp_bonus rw1 rw2 rw3 lz combat_skill_id)a

  def changeset(weapon, attrs) do
    weapon
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> validate_length(:name, max: 25)
    |> validate_number(:tp_dice, greater_than_or_equal_to: 0, less_than_or_equal_to: 3)
    |> validate_number(:tp_dice, greater_than_or_equal_to: 0, less_than: 10)
    |> validate_number(:rw1, greater_than: 0, less_than_or_equal_to: 50)
    |> validate_number(:rw2, greater_than: 0, less_than_or_equal_to: 100)
    |> validate_number(:rw3, greater_than: 0, less_than_or_equal_to: 200)
    |> validate_number(:lz, greater_than_or_equal_to: 1)
    |> foreign_key_constraint(:combat_skill_id)
    |> unique_constraint(:name)
  end

  def entries do
    [
      {15, "Balestrina", 1, 4, 5, 25, 40, 2},
      {15, "Balläster", 1, 3, 20, 60, 100, 2},
      {16, "Blasrohr", 0, 1, 5, 20, 40, 2},
      {18, "Diskus", 1, 2, 5, 25, 40, 2},
      {15, "Eisenwalder", 1, 4, 10, 50, 80, 2},
      {17, "Elfenbogen", 1, 5, 50, 100, 200, 1},
      {15, "Handarmbrust", 1, 3, 5, 25, 40, 3},
      {17, "Kompositbogen", 1, 7, 20, 100, 160, 2},
      {17, "Kurzbogen", 1, 4, 10, 50, 80, 1},
      {17, "Langbogen", 1, 8, 20, 100, 160, 2},
      {15, "Leichte Armbrust", 1, 6, 10, 50, 80, 8},
      {21, "Schneidzahn", 1, 4, 2, 10, 15, 2},
      {15, "Schwere Armbrust", 2, 6, 20, 100, 160, 15},
      {21, "Wurfbeil", 1, 3, 2, 10, 15, 1},
      {21, "Wurfdolch", 1, 1, 2, 10, 15, 1},
      {21, "Wurfkeule", 1, 2, 2, 10, 15, 1},
      {21, "Wurfnetz", 0, 0, 1, 3, 5, 1},
      {21, "Wurfring", 1, 1, 2, 10, 15, 1},
      {21, "Wurfscheibe", 1, 1, 2, 10, 15, 1},
      {21, "Wurfstern", 1, 1, 2, 10, 15, 1},
      {21, "Wurfspeer", 2, 2, 5, 25, 40, 2},
    ]
    |> Enum.map(fn {combat_skill_id, name, tp_dice, tp_bonus, rw1, rw2, rw3, lz} ->
      %{combat_skill_id: combat_skill_id, name: name, tp_dice: tp_dice, tp_bonus: tp_bonus, rw1: rw1, rw2: rw2, rw3: rw3, lz: lz}
    end)
  end
end
