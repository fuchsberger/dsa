defmodule Dsa.Lore.SpecialSkill do
  use Ecto.Schema

  import Ecto.Changeset

  schema "special_skills" do
    field :name, :string
    field :ap, :integer
    field :type, :integer # 0 passiv, 1 basic, 2 special, 3 generell
    field :modifier, :integer

    many_to_many :combat_skills, Dsa.Lore.CombatSkill, join_through: "combat_special_skills"

    many_to_many :characters, Dsa.Accounts.Character,
      join_through: Dsa.Accounts.CharacterCombatSkill,
      on_replace: :delete
  end

  @fields ~w(name ap type)a
  def changeset(skill, attrs) do
    skill
    |> cast(attrs, [:modifier | @fields])
    |> validate_required(@fields)
    |> validate_length(:name, max: 30)
    |> validate_number(:ap, greater_than: 0)
    |> validate_inclusion(:type, [0, 1, 2])
    |> unique_constraint(:name)
  end

  @all_combat_skills Enum.to_list(1..21)

  def entries do
    [
      {"Aufmerksamkeit", 10, 0, nil, @all_combat_skills},
      {"Belastungsgewöhnung I", 20, 0, nil, @all_combat_skills},
      {"Belastungsgewöhnung II", 35, 0, nil, @all_combat_skills},
      {"Beidhändiger Kampf I", 20, 0, nil, [1,3,4,8,9,10]},
      {"Beidhändiger Kampf II", 35, 0, nil, [1,3,4,8,9,10]},
      {"Berittener Kampf", 20, 0, nil, @all_combat_skills},
      {"Berittener Schütze", 10, 0, nil, [15, 17, 21]},
      {"Einhändiger Kampf", 10, 0, nil, [3, 10]},
      {"Entwaffnen", 40, 2, -4, [3, 4, 7, 8, 10, 11, 12, 13, 14]},
      {"Feindgespür", 10, 0, nil, @all_combat_skills},
      {"Finte I", 15, 1, -1, [1, 3, 4, 7, 8, 10, 12, 13, 14]},
      {"Finte II", 20, 1, -2, [1, 3, 4, 7, 8, 10, 12, 13, 14]},
      {"Finte III", 25, 1, -3, [1, 3, 4, 7, 8, 10, 12, 13, 14]},
      {"Haltegriff", 5, 2, nil, [8]},
      {"Hammerschlag", 25, 2, -2, [4, 5, 10, 13, 14]},
      {"Kampfreflexe I", 10, 0, nil, @all_combat_skills},
      {"Kampfreflexe II", 15, 0, nil, @all_combat_skills},
      {"Kampfreflexe III", 20, 0, nil, @all_combat_skills},
      {"Klingenfänger", 10, 0, nil, [1]},
      {"Kreuzblock", 10, 0, nil, [1, 3]},
      {"Lanzenangriff", 10, 2, nil, [6]},
      {"Präziser Schuss/Wurf I", 15, 1, -2, [15, 16, 17, 18, 20, 21]},
      {"Präziser Schuss/Wurf II", 20, 1, -4, [15, 16, 17, 18, 20, 21]},
      {"Präziser Schuss/Wurf III", 25, 1, -6, [15, 16, 17, 18, 20, 21]},
      {"Präziser Stich I", 15, 1, -2, [1, 3]},
      {"Präziser Stich II", 20, 1, -4, [1, 3]},
      {"Präziser Stich III", 25, 1, -6, [1, 3]},
      {"Riposte", 40, 2, -2, [1, 3]},
      {"Rundumschlag I", 25, 1, -2, [4, 5, 9, 10, 12, 13, 14]},
      {"Rundumschlag II", 35, 2, -2, [4, 5, 9, 10, 12, 13, 14]},
      {"Schildspalter", 15, 2, nil, [4, 5, 13, 14]},
      {"Schnellladen (Armbrüste)", 5, 0, nil, [15]},
      {"Schnellladen (Bögen)", 20, 0, nil, [17]},
      {"Schnellladen (Wurfwaffen)", 10, 0, nil, [21]},
      {"Schnellziehen", 10, 0, nil, [1, 3, 4, 5, 7, 10, 12, 13, 14]},
      {"Sturmangriff", 25, 2, -2, [4, 10, 12, 13, 14]},
      {"Todesstoß", 30, 2, -2, [1, 3]},
      {"Verbessertes Ausweichen I", 15, 0, nil, @all_combat_skills},
      {"Verbessertes Ausweichen II", 20, 0, nil, @all_combat_skills},
      {"Verbessertes Ausweichen III", 25, 0, nil, @all_combat_skills},
      {"Verteidigungshaltung", 10, 0, nil, [1, 3, 4, 8, 9, 10, 12, 13, 14]},
      {"Vorstoß", 10, 2, 2, [1, 3, 4, 5, 8, 10, 12, 13, 14]},
      {"Wuchtschlag I", 15, 1, -2, [4, 5, 8, 10, 12, 13, 14]},
      {"Wuchtschlag II", 20, 1, -4, [4, 5, 8, 10, 12, 13, 14]},
      {"Wuchtschlag III", 25, 1, -6, [4, 5, 8, 10, 12, 13, 14]},
      {"Wurf", 10, 2, -2, [8]},
      {"Zu Fall bringen", 20, 2, -4, [7, 12]},
      # Ruestkammer erweiterung
      {"Schnellladen (Blasrohre)", 5, 0, nil, [16]},
      {"Schnellladen (Diskusse)", 5, 0, nil, [18]},
      {"Schnellladen (Schleudern)", 5, 0, nil, [20]},
      {"Ballistischer Schuss", 10, 2, -2, [17]},
      {"Betäubungsschlag", 15, 2, -2, [4, 10, 12]},
      {"Festnageln", 20, 2, -4, [12]},
      {"Klingensturm", 25, 2, -2, [1, 3, 4, 10]},
      {"Unterlaufen I", 10, 1, -2, [1, 3, 4, 5, 8, 9, 10, 13, 14]},
      {"Unterlaufen II", 15, 1, -4, [1, 3, 4, 5, 8, 9, 10, 13, 14]},
      {"Binden", 25, 2, -2, [1, 3, 10, 12]},
      {"Hohe Klinge", 15, 2, nil, [3, 10, 14]},
      {"Sprungangriff", 20, 2, nil, [3, 10, 14]},
      {"Vorbeiziehen", 15, 2, -4, [1, 3, 4, 10]},
      {"Weiter Schwung", 15, 1, -2, [13, 14]},
      {"Windmühle", 25, 2, -2, [4, 10, 13, 13, 14]},
      {"Wuchtiger Wurf", 15, 2, nil, [21]},
      {"Zertrümmern", 5, 2, nil, [4, 5, 13]},
      {"Drohgebärden", 10, 0, nil, @all_combat_skills},
    ]
    |> Enum.map(fn {name, ap, type, modifier, combat_skills} ->
      {%{name: name, ap: ap, type: type, modifier: modifier}, combat_skills}
    end)
  end
end
