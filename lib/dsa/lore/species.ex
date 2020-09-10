defmodule Dsa.Lore.Species do
  use Ecto.Schema

  import Ecto.Changeset

  schema "species" do
    field :name, :string
    field :le, :integer
    field :sk, :integer
    field :zk, :integer
    field :gs, :integer
    field :ap, :integer
  end

  @fields ~w(name le sk zk gs ap)a
  def changeset(skill, attrs) do
    skill
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> validate_length(:name, max: 10)
    |> unique_constraint(:name)
  end

  def entries do
    [
      { "Mensch",  5, -5, -5, 8, 0},
      { "Elf",     2, -4, -6, 8, 18},
      { "Halbelf", 5, -4, -6, 8, 0},
      { "Zwerg",   8, -4, -4, 6, 61}
    ]
    |> Enum.map(fn {name, le, sk, zk, gs, ap} ->
      %{name: name, le: le, sk: sk, zk: zk, gs: gs, ap: ap}
    end)
  end
end
