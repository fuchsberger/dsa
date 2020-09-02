defmodule Dsa.Lore.SpecialSkill do
  use Ecto.Schema

  import Ecto.Changeset

  schema "special_skills" do
    field :name, :string
    field :ap, :integer
    field :type, :integer # 0 passiv, 1 basic, 2 special
    field :modifier, :integer

    many_to_many :combat_skills, Dsa.Lore.CombatSkill, join_through: "combat_special_skills"

    many_to_many :characters, Dsa.Accounts.Character,
      join_through: Dsa.Accounts.CharacterCombatSkill,
      on_replace: :delete
  end

  @fields ~w(id name ap type)a

  def changeset(skill, attrs) do
    skill
    |> cast(attrs, [:modifier | @fields])
    |> validate_required(@fields)
    |> validate_length(:name, max: 30)
    |> validate_number(:ap, greater_than: 0)
    |> validate_inclusion(:type, [0, 1, 2])
  end

  @all_combat_skills Enum.to_list(1..21)

  def entries do
    [
      {1, "Aufmerksamkeit", 10, 0, nil, @all_combat_skills},
      {2, "Belastungsgewöhnung I", 20, 0, nil, @all_combat_skills},
      {3, "Belastungsgewöhnung II", 35, 0, nil, @all_combat_skills},
      {4, "Beidhändiger Kampf I", 20, 0, nil, [1,3,4,8,9,10]},
      {5, "Beidhändiger Kampf II", 35, 0, nil, [1,3,4,8,9,10]},
      {6, "Berittener Kampf", 20, 0, nil, @all_combat_skills},
      {7, "Berittener Schütze", 10, 0, nil, [15, 17, 21]},
      {8, "Einhändiger Kampf", 10, 0, nil, [3, 10]},
      {9, "Entwaffnen", 40, 2, -4, [3, 4, 7, 8, 10, 11, 12, 13, 14]},
      {10, "Feindgespür", 10, 0, nil, @all_combat_skills},
      {11, "Finte I", 15, 1, -1, [1, 3, 4, 7, 8, 10, 12, 13, 14]},
      {12, "Finte II", 20, 1, -2, [1, 3, 4, 7, 8, 10, 12, 13, 14]},
      {13, "Finte III", 25, 1, -3, [1, 3, 4, 7, 8, 10, 12, 13, 14]},
      {14, "Haltegriff", 5, 2, nil, [8]},
      {15, "Hammerschlag", 25, 2, -2, [4, 5, 10, 13, 14]},
      {16, "Kampfreflexe I", 10, 0, nil, @all_combat_skills},
      {17, "Kampfreflexe II", 15, 0, nil, @all_combat_skills},
      {18, "Kampfreflexe III", 20, 0, nil, @all_combat_skills},
      {19, "Klingenfänger", 10, 0, nil, [1]},
      {20, "Kreuzblock", 10, 0, nil, [1, 3]},
      {21, "Lanzenangriff", 10, 2, nil, [6]},
      {22, "Präziser Schuss/Wurf I", 15, 1, -2, [15, 16, 17, 18, 20, 21]},
      {23, "Präziser Schuss/Wurf II", 20, 1, -4, [15, 16, 17, 18, 20, 21]},
      {24, "Präziser Schuss/Wurf III", 25, 1, -6, [15, 16, 17, 18, 20, 21]},
      {25, "Präziser Stich I", 15, 1, -2, [1, 3]},
      {26, "Präziser Stich II", 20, 1, -4, [1, 3]},
      {27, "Präziser Stich III", 25, 1, -6, [1, 3]},
      {28, "Riposte", 40, 2, -2, [1, 3]},
      {29, "Rundumschlag I", 25, 1, -2, [4, 5, 9, 10, 12, 13, 14]},
      {30, "Rundumschlag II", 35, 2, -2, [4, 5, 9, 10, 12, 13, 14]},
      {31, "Schildspalter", 15, 2, nil, [4, 5, 13, 14]},
      {32, "Schnellladen (Armbrüste)", 5, 0, nil, [15]},
      {33, "Schnellladen (Bögen)", 20, 0, nil, [17]},
      {34, "Schnellladen (Wurfwaffen)", 10, 0, nil, [21]},
      {35, "Schnellziehen", 10, 0, nil, [1, 3, 4, 5, 7, 10, 12, 13, 14]},
      {36, "Sturmangriff", 25, 2, -2, [4, 10, 12, 13, 14]},
      {37, "Todesstoß", 30, 2, -2, [1, 3]},
      {38, "Verbessertes Ausweichen I", 15, 0, nil, @all_combat_skills},
      {39, "Verbessertes Ausweichen II", 20, 0, nil, @all_combat_skills},
      {40, "Verbessertes Ausweichen III", 25, 0, nil, @all_combat_skills},
      {41, "Verteidigungshaltung", 10, 0, nil, [1, 3, 4, 8, 9, 10, 12, 13, 14]},
      {42, "Vorstoß", 10, 2, 2, [1, 3, 4, 5, 8, 10, 12, 13, 14]},
      {43, "Wuchtschlag I", 15, 1, -2, [4, 5, 8, 10, 12, 13, 14]},
      {44, "Wuchtschlag II", 20, 1, -4, [4, 5, 8, 10, 12, 13, 14]},
      {45, "Wuchtschlag III", 25, 1, -6, [4, 5, 8, 10, 12, 13, 14]},
      {46, "Wurf", 10, 2, -2, [8]},
      {47, "Zu Fall bringen", 20, 2, -4, [7, 12]},
      # Ruestkammer erweiterung
      {48, "Schnellladen (Blasrohre)", 5, 0, nil, [16]},
      {49, "Schnellladen (Diskusse)", 5, 0, nil, [18]},
      {50, "Schnellladen (Schleudern)", 5, 0, nil, [20]},
      {51, "Ballistischer Schuss", 10, 2, -2, [17]},
      {52, "Betäubungsschlag", 15, 2, -2, [4, 10, 12]},
      {53, "Festnageln", 20, 2, -4, [12]},
      {54, "Klingensturm", 25, 2, -2, [1, 3, 4, 10]},
      {55, "Unterlaufen I", 10, 1, -2, [1, 3, 4, 5, 8, 9, 10, 13, 14]},
      {56, "Unterlaufen II", 15, 1, -4, [1, 3, 4, 5, 8, 9, 10, 13, 14]},
      {57, "Binden", 25, 2, -2, [1, 3, 10, 12]},
      {58, "Hohe Klinge", 15, 2, nil, [3, 10, 14]},
      {59, "Sprungangriff", 20, 2, nil, [3, 10, 14]},
      {60, "Vorbeiziehen", 15, 2, -4, [1, 3, 4, 10]},
      {61, "Weiter Schwung", 15, 1, -2, [13, 14]},
      {62, "Windmühle", 25, 2, -2, [4, 10, 13, 13, 14]},
      {63, "Wuchtiger Wurf", 15, 2, nil, [21]},
      {64, "Zertrümmern", 5, 2, nil, [4, 5, 13]},
      {65, "Drohgebärden", 10, 0, nil, @all_combat_skills},
    ]
    |> Enum.map(fn {id, name, ap, type, modifier, combat_skills} ->
      {%{id: id, name: name, ap: ap, type: type, modifier: modifier}, combat_skills}
    end)
  end
end
