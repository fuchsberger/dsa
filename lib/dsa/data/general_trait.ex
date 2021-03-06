defmodule Dsa.Data.GeneralTrait do
  @moduledoc """
  CharacterScript module
  """
  use Ecto.Schema
  import Ecto.Changeset

  @table :general_traits

  schema "general_traits" do
    field :general_trait_id, :integer
    field :details, :string
    belongs_to :character, Dsa.Characters.Character
  end

  def changeset(general_trait, params \\ %{}) do
    general_trait
    |> cast(params, [:general_trait_id, :character_id, :details])
    |> validate_required([:general_trait_id, :character_id])
    |> validate_length(:details, max: 50)
    |> validate_number(:general_trait_id, greater_than: 0, less_than_or_equal_to: count())
    |> foreign_key_constraint(:character_id)
  end

  def count, do: :ets.info(@table, :size)
  def list, do: :ets.tab2list(@table)

  def options, do: Enum.map(list(), fn {id, name, ap, _details} -> {"#{name} (#{ap})", id} end)

  def name(id), do: :ets.lookup_element(@table, id, 2)
  def ap(id), do: :ets.lookup_element(@table, id, 3)
  def details(id), do: :ets.lookup_element(@table, id, 4)

  def seed do
    :ets.new(@table , [:ordered_set, :protected, :named_table])
    :ets.insert(@table, [
      # {id, name, ap, details}
      {1, "Analytiker", 5, false},
      {2, "Anführer", 10, false},
      {3, "Berufsgeheimnis", 1, true},
      {4, "Berufsgeheimnis", 2, true},
      {5, "Berufsgeheimnis", 3, true},
      {6, "Berufsgeheimnis", 4, true},
      {7, "Berufsgeheimnis", 5, true},
      {8, "Berufsgeheimnis", 6, true},
      {9, "Berufsgeheimnis", 7, true},
      {10, "Berufsgeheimnis", 8, true},
      {11, "Berufsgeheimnis", 10, true},
      {12, "Berufsgeheimnis", 15, true},
      {13, "Berufsgeheimnis", 20, true},
      {14, "Dokumentfälscher", 5, false},
      {15, "Eiserner Wille I", 15, false},
      {16, "Eiserner Wille II", 15, false},
      {17, "Fächersprache", 3, false},
      {18, "Fallen entschärfen", 5, false},
      {19, "Falschspielen", 5, false},
      {20, "Fertigkeitsspezialisierung", 1, true},
      {21, "Fertigkeitsspezialisierung", 2, true},
      {22, "Fertigkeitsspezialisierung", 3, true},
      {23, "Fertigkeitsspezialisierung", 4, true},
      {24, "Fertigkeitsspezialisierung", 6, true},
      {25, "Fertigkeitsspezialisierung", 8, true},
      {26, "Fertigkeitsspezialisierung", 9, true},
      {27, "Fertigkeitsspezialisierung", 12, true},
      {28, "Fischer", 3, false},
      {29, "Füchsisch", 3, false},
      {30, "Geländekunde", 15, false},
      {31, "Gildenrecht", 2, false},
      {32, "Glasbläserei", 2, false},
      {33, "Hehlerei", 5, false},
      {34, "Heraldik", 2, false},
      {35, "Instrumente bauen", 2, false},
      {36, "Jäger", 5, false},
      {37, "Kartographie", 5, false},
      {38, "Lippenlesen", 10, false},
      {39, "Meister der Improvisation", 10, false},
      {40, "Ortskenntnis (Heimat):", 0, true},
      {41, "Ortskenntnis", 2, true},
      {42, "Rosstäuscher", 5, false},
      {43, "Sammler", 2, false},
      {44, "Schmerzen unterdrücken", 20, false},
      {45, "Schnapsbrennerei", 2, false},
      {46, "Schriftstellerei", 2, true},
      {47, "Tierstimmen imitieren", 5, false},
      {48, "Töpferei", 2, false},
      {49, "Wettervorhersage", 2, false},
      {50, "Zahlenmystik", 2, false},
    ])
  end
end
