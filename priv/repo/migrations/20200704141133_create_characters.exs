defmodule Dsa.Repo.Migrations.CreateCharacters do
  use Ecto.Migration

  import Dsa
  alias Dsa.Data.Skill

  def change do
    create table(:characters) do

      # general
      add :name, :string
      add :title, :string
      add :height, :float
      add :weight, :integer
      add :origin, :string
      add :birthday, :string
      add :age, :integer
      add :culture, :string
      add :profession, :string

      # base values
      Enum.each(base_values(), & add(&1, :integer))

      # skills
      Enum.each(combat_fields(), & add(&1, :integer))
      Enum.each(Skill.fields(), & add(&1, :integer))

      # combat
      add :at, :integer
      add :pa, :integer
      add :tp_dice, :integer
      add :tp_bonus, :integer
      add :be, :integer
      add :rs, :integer

      # stats
      add :le_bonus, :integer
      add :le_lost, :integer
      add :ae_bonus, :integer
      add :ae_lost, :integer
      add :ae_back, :integer
      add :ke_bonus, :integer
      add :ke_lost, :integer
      add :ke_back, :integer

      # overwrites
      add :le, :integer
      add :ke, :integer
      add :ae, :integer
      add :sk, :integer
      add :zk, :integer
      add :ini, :integer
      add :gs, :integer
      add :aw, :integer
      add :sp, :integer

      # ets relations
      add :species_id, :integer
      add :magic_tradition_id, :integer
      add :karmal_tradition_id, :integer

      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end
    create index(:characters, [:user_id])

    alter table(:users) do
      add :active_character_id, references(:characters, on_delete: :nilify_all)
    end

    create index(:users, [:active_character_id])
  end
end
