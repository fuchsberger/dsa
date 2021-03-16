defmodule Dsa.Accounts.Group do
  use Ecto.Schema
  import Ecto.Changeset

  schema "groups" do
    field :name, :string
    belongs_to :master, Dsa.Accounts.User
    has_many :users, Dsa.Accounts.User
    has_many :skill_rolls, Dsa.Event.SkillRoll
    has_many :spell_rolls, Dsa.Event.SpellRoll
    timestamps()
  end

  def changeset(group, attrs) do
    group
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, max: 10)
  end
end
