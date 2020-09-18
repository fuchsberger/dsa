defmodule Dsa.Data.GeneralTrait do
  @moduledoc """
  CharacterScript module
  """
  use Ecto.Schema
  import Ecto.Changeset

  @table :general_traits

  @primary_key false
  schema "general_traits" do
    field :id, :integer, primary_key: true
    field :ap, :integer
    field :details, :string
    belongs_to :character, Dsa.Accounts.Character, primary_key: true
  end

  @fields ~w(id ap character_id)a
  def changeset(general_trait, params \\ %{}) do
    general_trait
    |> cast(params, [:details | @fields])
    |> validate_required(@fields)
    |> validate_length(:details, max: 50)
    |> validate_number(:ap, greater_than: 0)
    |> validate_number(:id, greater_than: 0, less_than_or_equal_to: count())
    |> foreign_key_constraint(:character_id)
    |> unique_constraint([:character_id, :id])
  end

  def count, do: 32
  def list, do: :ets.tab2list(@table)

  def get(id), do: List.first(:ets.lookup(@table, id))

  def options(), do: Enum.map(list(), fn {id, name, _ap, _details, _fixed_ap} -> {name, id} end)

  def name(id), do: :ets.lookup_element(@table, id, 2)
  def ap(id), do: :ets.lookup_element(@table, id, 3)
  def details(id), do: :ets.lookup_element(@table, id, 4)
  def fixed_ap(id), do: :ets.lookup_element(@table, id, 5)

  def seed do
    :ets.new(@table , [:ordered_set, :protected, :named_table])
    :ets.insert(@table, [
      # {id, name, ap, details, fixed_ap}
      {1, "Analytiker", 5, false, true},
      {2, "Anführer", 10, false, true},
      {3, "Berufsgeheimnis", 1, true, false},
      {4, "Dokumentfälscher", 5, false, true},
      {5, "Eiserner Wille I", 15, false, true},
      {6, "Eiserner Wille II", 15, false, true},
      {7, "Fächersprache", 3, false, true},
      {8, "Fallen entschärfen", 5, false, true},
      {9, "Falschspielen", 5, false, true},
      {10, "Fertigkeitsspezialisierung (Talente)", 1, true, false},
      {11, "Fischer", 3, false, true},
      {12, "Füchsisch", 3, false, true},
      {13, "Geländekunde", 15, false, true},
      {14, "Gildenrecht", 2, false, true},
      {15, "Glasbläserei", 2, false, true},
      {16, "Hehlerei", 5, false, true},
      {17, "Heraldik", 2, false, true},
      {18, "Instrumente bauen", 2, false, true},
      {19, "Jäger", 5, false, true},
      {20, "Kartographie", 5, false, true},
      {211, "Lippenlesen", 10, false, true},
      {22, "Meister der Improvisation", 10, false, true},
      {23, "Ortskenntnis", 2, true, false},
      {24, "Rosstäuscher", 5, false, true},
      {25, "Sammler", 2, false, true},
      {26, "Schmerzen unterdrücken", 20, false, true},
      {27, "Schnapsbrennerei", 2, false, true},
      {28, "Schriftstellerei", 2, true, true},
      {29, "Tierstimmen imitieren", 5, false, true},
      {30, "Töpferei", 2, false, true},
      {31, "Wettervorhersage", 2, false, true},
      {32, "Zahlenmystik", 2, false, true},
    ])
  end
end
