defmodule Dsa.Repo.Migrations.SetIniDefault do
  use Ecto.Migration

  def change do
    execute "UPDATE characters SET be=0 WHERE be IS NULL", ""
    execute "UPDATE characters SET gs=0 WHERE gs IS NULL", ""
    execute "UPDATE characters SET ini=0 WHERE ini IS NULL", ""
    execute "UPDATE characters SET rs=0 WHERE rs IS NULL", ""

    alter table(:characters) do
      remove :at, :integer, default: 0
      remove :pa, :integer, default: 0
      remove :tp_dice, :integer, default: 0
      remove :tp_bonus, :integer, default: 0
      remove :aw, :integer, default: 0

      modify :be, :integer, default: 0, null: false, from: :integer
      modify :gs, :integer, default: 0, null: false, from: :integer
      modify :ini, :integer, default: 0, null: false, from: :integer
      modify :rs, :integer, default: 0, null: false, from: :integer
    end
  end
end
