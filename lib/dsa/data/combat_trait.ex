defmodule Dsa.Data.CombatTrait do
  @moduledoc """
  CharacterScript module
  """
  use Ecto.Schema
  import Ecto.Changeset

  @table :combat_traits

  @primary_key false
  schema "combat_traits" do
    field :id, :integer, primary_key: true
    belongs_to :character, Dsa.Characters.Character, primary_key: true
  end

  @fields ~w(id character_id)a
  def changeset(combat_trait, params \\ %{}) do
    combat_trait
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_number(:id, greater_than: 0, less_than_or_equal_to: count())
    |> foreign_key_constraint(:character_id)
    |> unique_constraint([:character_id, :id])
  end

  def count, do: 65
  def list, do: :ets.tab2list(@table)

  def get(id), do: List.first(:ets.lookup(@table, id))

  def options(ctraits) do
    list()
    |> Enum.map(fn {id, name, _ap} -> {name, id} end)
    |> Enum.reject(fn {_name, id} -> Enum.member?(Enum.map(ctraits, & &1.id), id) end)
  end

  def name(id), do: :ets.lookup_element(@table, id, 2)
  def ap(id), do: :ets.lookup_element(@table, id, 3)

  def seed do
    :ets.new(@table , [:ordered_set, :protected, :named_table])
    :ets.insert(@table, [
      # {id, name, ap}
      {1, "Aufmerksamkeit", 10}, # @all_combat_skills},
      {2, "Ballistischer Schuss", 10}, # [17]},
      {3, "Belastungsgewöhnung I", 20}, # @all_combat_skills},
      {4, "Belastungsgewöhnung II", 35}, # @all_combat_skills},
      {5, "Beidhändiger Kampf I", 20}, # [1,3,4,8,9,10]},
      {6, "Beidhändiger Kampf II", 35}, # [1,3,4,8,9,10]},
      {7, "Betäubungsschlag", 15}, # [4, 10, 12]},
      {8, "Berittener Kampf", 20}, # @all_combat_skills},
      {9, "Berittener Schütze", 10}, # [15, 17, 21]},
      {10, "Binden", 25}, # [1, 3, 10, 12]},
      {11, "Drohgebärden", 10}, # @all_combat_skills}
      {12, "Einhändiger Kampf", 10}, # [3, 10]},
      {13, "Entwaffnen", 40}, # [3, 4, 7, 8, 10, 11, 12, 13, 14]},
      {14, "Feindgespür", 10}, # @all_combat_skills},
      {15, "Festnageln", 20}, # [12]},
      {16, "Finte I", 15}, # [1, 3, 4, 7, 8, 10, 12, 13, 14]},
      {17, "Finte II", 20}, # [1, 3, 4, 7, 8, 10, 12, 13, 14]},
      {18, "Finte III", 25}, # [1, 3, 4, 7, 8, 10, 12, 13, 14]},
      {19, "Haltegriff", 5}, # [8]},
      {20, "Hammerschlag", 25}, # [4, 5, 10, 13, 14]},
      {21, "Hohe Klinge", 15}, # [3, 10, 14]},
      {22, "Kampfreflexe I", 10}, # @all_combat_skills}, // done
      {23, "Kampfreflexe II", 15}, # @all_combat_skills}, // done
      {24, "Kampfreflexe III", 20}, # @all_combat_skills}, // done
      {25, "Klingenfänger", 10}, # [1]},
      {26, "Klingensturm", 25}, # [1, 3, 4, 10]},
      {27, "Kreuzblock", 10}, # [1, 3]},
      {28, "Lanzenangriff", 10}, # [6]},
      {29, "Präziser Schuss/Wurf I", 15}, # [15, 16, 17, 18, 20, 21]},
      {30, "Präziser Schuss/Wurf II", 20}, # [15, 16, 17, 18, 20, 21]},
      {31, "Präziser Schuss/Wurf III", 25}, # [15, 16, 17, 18, 20, 21]},
      {32, "Präziser Stich I", 15}, # [1, 3]},
      {33, "Präziser Stich II", 20}, # [1, 3]},
      {34, "Präziser Stich III", 25}, # [1, 3]},
      {35, "Riposte", 40}, # [1, 3]},
      {36, "Rundumschlag I", 25}, # [4, 5, 9, 10, 12, 13, 14]},
      {37, "Rundumschlag II", 35}, # [4, 5, 9, 10, 12, 13, 14]},
      {38, "Schildspalter", 15}, # [4, 5, 13, 14]},
      {39, "Schnellladen (Armbrüste)", 5}, # [15]},
      {40, "Schnellladen (Blasrohre)", 5}, # [16]},
      {41, "Schnellladen (Bögen)", 20}, # [17]},
      {42, "Schnellladen (Diskusse)", 5}, # [18]},
      {43, "Schnellladen (Schleudern)", 5}, # [20]},
      {44, "Schnellladen (Wurfwaffen)", 10}, # [21]},
      {45, "Schnellziehen", 10}, # [1, 3, 4, 5, 7, 10, 12, 13, 14]},
      {46, "Sprungangriff", 20}, # [3, 10, 14]},
      {47, "Sturmangriff", 25}, # [4, 10, 12, 13, 14]},
      {48, "Todesstoß", 30}, # [1, 3]},
      {49, "Unterlaufen I", 10}, # [1, 3, 4, 5, 8, 9, 10, 13, 14]},
      {50, "Unterlaufen II", 15}, # [1, 3, 4, 5, 8, 9, 10, 13, 14]},
      {51, "Verbessertes Ausweichen I", 15}, # @all_combat_skills
      {52, "Verbessertes Ausweichen II", 20}, # @all_combat_skills
      {53, "Verbessertes Ausweichen III", 25},
      {54, "Verteidigungshaltung", 10}, # [1, 3, 4, 8, 9, 10, 12, 13, 14]},
      {55, "Vorbeiziehen", 15}, # [1, 3, 4, 10]},
      {56, "Vorstoß", 10}, # [1, 3, 4, 5, 8, 10, 12, 13, 14]},
      {57, "Weiter Schwung", 15}, # [13, 14]},
      {58, "Windmühle", 25}, # [4, 10, 13, 13, 14]},
      {59, "Wuchtiger Wurf", 15}, # [21]},
      {60, "Wuchtschlag I", 15}, # [4, 5, 8, 10, 12, 13, 14]},
      {61, "Wuchtschlag II", 20}, # [4, 5, 8, 10, 12, 13, 14]},
      {62, "Wuchtschlag III", 25}, # [4, 5, 8, 10, 12, 13, 14]},
      {63, "Wurf", 10}, # [8]},
      {64, "Zertrümmern", 5}, # [4, 5, 13]},
      {65, "Zu Fall bringen", 20}, # [7, 12]},
    ])
  end
end
