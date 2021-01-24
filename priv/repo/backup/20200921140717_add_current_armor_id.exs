defmodule Dsa.Repo.Migrations.AddCurrentArmorId do
  use Ecto.Migration

  def change do
    alter table (:characters) do
      add :armor_id, references(:armors, on_delete: :nilify_all)
    end
    create index :characters, [:armor_id]
  end
end
