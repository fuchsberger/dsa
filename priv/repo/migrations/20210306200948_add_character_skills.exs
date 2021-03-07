defmodule Dsa.Repo.Migrations.AddCharacterSkills do
  use Ecto.Migration

  def change do
    create table(:character_skills, primary_key: false) do
      add :level, :smallint, null: false
      add :character_id, references(:characters, on_delete: :nilify_all), primary_key: true
      add :skill_id, references(:skills, on_delete: :nilify_all), primary_key: true
    end

    create index :character_skills, [:character_id, :skill_id]

    alter table(:characters) do
      Enum.each(1..59, & remove(String.to_atom("t#{&1}"), :integer))
    end
  end
end
