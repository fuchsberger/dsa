defmodule Dsa.Repo.Migrations.CreateSpecialSkills do
  use Ecto.Migration

  def change do

    create table(:special_skills) do
      add :name, :string
      add :ap, :integer
      add :type, :integer
      add :modifier, :integer
    end

    create table(:character_special_skills, primary_key: false) do
      add :character_id, references(:characters, on_delete: :delete_all), primary_key: true
      add :special_skill_id, references(:special_skills, on_delete: :delete_all), primary_key: true
    end

    create unique_index :character_special_skills, [:character_id, :special_skill_id]

    create table(:combat_special_skills, primary_key: false) do
      add :combat_skill_id, references(:combat_skills, on_delete: :delete_all), primary_key: true
      add :special_skill_id, references(:special_skills, on_delete: :delete_all), primary_key: true
    end

    create unique_index :combat_special_skills, [:combat_skill_id, :special_skill_id]
  end
end
