defmodule Dsa.Lore.Armor do
  use Ecto.Schema

  import Ecto.Changeset

  schema "armors" do
    field :name, :string
    field :rs, :integer
    field :be, :integer
    field :sw, :integer
    field :penalties, :boolean, default: false
  end

  @fields ~w(name rs be sw penalties)a
  def changeset(skill, attrs) do
    skill
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> validate_length(:name, max: 25)
    |> validate_number(:rs, greater_than_or_equal_to: 0, less_than: 12)
    |> validate_number(:be, greater_than_or_equal_to: 0, less_than: 6)
    |> validate_number(:sw, greater_than_or_equal_to: 0)
  end

  def entries do
    [
      { "Schwere Kleidung / Winter", 1, 0, 5, true },
      { "Iryanrüstung", 3, 1, 8, true },
      { "Kettenhemd", 4, 2, 13, false },
      { "Krötenhaut", 3, 1, 8, true },
      { "Lederharnisch", 3, 1, 8, true },
      { "Leichte Platte", 6, 3, 11, false },
      { "Schuppenpanzer", 5, 2, 12, true },
      { "Spiegelpanzer", 4, 2, 13, false },
      { "Tuchrüstung", 2, 1, 6, false }
    ]
    |> Enum.map(fn {name, rs, be, sw, penalties} ->
      %{name: name, rs: rs, be: be, sw: sw, penalties: penalties}
    end)
  end
end
