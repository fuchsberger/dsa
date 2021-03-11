defmodule Dsa.Repo.Migrations.AddCharacterSpells do
  use Ecto.Migration

  def change do
    create table(:character_spells, primary_key: false) do
      add :level, :smallint, null: false
      add :character_id, references(:characters, on_delete: :nilify_all), primary_key: true
      add :spell_id, references(:spells, on_delete: :nilify_all), primary_key: true
    end

    create index :character_spells, [:character_id, :spell_id]

    alter table(:characters) do
      Enum.each(1..51, & remove(String.to_atom("s#{&1}"), :integer))
    end
  end
end
