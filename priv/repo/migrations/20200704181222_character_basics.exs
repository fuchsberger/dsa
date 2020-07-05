defmodule Dsa.Repo.Migrations.CharacterBasics do
  use Ecto.Migration

  def change do
    alter table(:characters) do
      add :ap, :integer
      add :species, :string
      add :culture, :string
      add :profession, :string
      add :title, :string
      add :eyecolor, :string
      add :height, :integer
      add :weight, :integer
      add :birthplace, :string
      add :haircolor, :string
      add :created, :boolean
      add :mu, :integer
      add :kl, :integer
      add :in, :integer
      add :ch, :integer
      add :ff, :integer
      add :ge, :integer
      add :ko, :integer
      add :kk, :integer
    end
  end
end
