defmodule Dsa.Repo.Migrations.RenameSpellFieldSpread do
  use Ecto.Migration

  def change do
    rename table(:spells), :traditions, to: :spread
  end
end
