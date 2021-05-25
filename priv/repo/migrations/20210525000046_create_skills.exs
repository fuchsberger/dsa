defmodule Dsa.Repo.Migrations.CreateSkills do
  use Ecto.Migration

  def change do
    create table(:skills) do
      add :applications, {:array, :string}
      add :name, :string
      add :slug, :string
      add :description, :text
      add :encumbrance_default, :boolean, null: false
      add :encumbrance_conditional, :string
      add :category, :smallint
      add :check, :smallint
      add :cost_factor, :smallint
      add :quality, :string
      add :failure, :string
      add :success, :string
      add :botch, :string
      add :book, :string
      add :page, :smallint
      add :tools, :string
    end

    create unique_index(:skills, [:name])
  end
end
