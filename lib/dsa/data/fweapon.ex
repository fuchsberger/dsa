defmodule Dsa.Data.FWeapon do
  @moduledoc """
  CharacterFWeapon module
  """
  use Ecto.Schema
  use Phoenix.HTML
  import Ecto.Changeset

  @table :fweapons

  @primary_key false
  schema "fweapons" do
    field :dmg, :integer, default: 0
    field :id, :integer, primary_key: true
    belongs_to :character, Dsa.Characters.Character, primary_key: true
  end

  @fields ~w(character_id id dmg)a
  def changeset(fweapon, params) do
    fweapon
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_number(:dmg, greater_than_or_equal_to: 0, less_than_or_equal_to: 4)
    |> validate_number(:id, greater_than: 0, less_than_or_equal_to: count())
    |> foreign_key_constraint(:character_id)
    |> unique_constraint([:character_id, :id])
  end

  def count, do: 21
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
  def rw1(id), do: :ets.lookup_element(@table, id, 6)
  def rw2(id), do: :ets.lookup_element(@table, id, 7)
  def rw3(id), do: :ets.lookup_element(@table, id, 8)
  def lz(id), do: :ets.lookup_element(@table, id, 9)

  def tooltip(_id) do
    ~E"""
    <p class="small mb-1">TODO</p>
    """
  end

  def seed do
    :ets.new(@table , [:ordered_set, :protected, :named_table])
    :ets.insert(@table, [
      # {id, combat_skill_id, name, tp_dice, tp_bonus, rw1, rw2, rw3, lz}
      {1, 15, "Balestrina", 1, 4, 5, 25, 40, 2},
      {2, 15, "Balläster", 1, 3, 20, 60, 100, 2},
      {3, 16, "Blasrohr", 0, 1, 5, 20, 40, 2},
      {4, 18, "Diskus", 1, 2, 5, 25, 40, 2},
      {5, 15, "Eisenwalder", 1, 4, 10, 50, 80, 2},
      {6, 17, "Elfenbogen", 1, 5, 50, 100, 200, 1},
      {7, 15, "Handarmbrust", 1, 3, 5, 25, 40, 3},
      {8, 17, "Kompositbogen", 1, 7, 20, 100, 160, 2},
      {9, 17, "Kurzbogen", 1, 4, 10, 50, 80, 1},
      {10, 17, "Langbogen", 1, 8, 20, 100, 160, 2},
      {11, 15, "Leichte Armbrust", 1, 6, 10, 50, 80, 8},
      {12, 21, "Schneidzahn", 1, 4, 2, 10, 15, 2},
      {13, 15, "Schwere Armbrust", 2, 6, 20, 100, 160, 15},
      {14, 21, "Wurfbeil", 1, 3, 2, 10, 15, 1},
      {15, 21, "Wurfdolch", 1, 1, 2, 10, 15, 1},
      {16, 21, "Wurfkeule", 1, 2, 2, 10, 15, 1},
      {17, 21, "Wurfnetz", 0, 0, 1, 3, 5, 1},
      {18, 21, "Wurfring", 1, 1, 2, 10, 15, 1},
      {19, 21, "Wurfscheibe", 1, 1, 2, 10, 15, 1},
      {20, 21, "Wurfstern", 1, 1, 2, 10, 15, 1},
      {21, 21, "Wurfspeer", 2, 2, 5, 25, 40, 2}
    ])
  end
end
