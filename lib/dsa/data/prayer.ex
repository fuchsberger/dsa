defmodule Dsa.Data.Prayer do
  @moduledoc """
  CharacterCast module
  """
  use Ecto.Schema
  use Phoenix.HTML
  import Ecto.Changeset

  @table :prayers

  @primary_key false
  schema "prayers" do
    field :level, :integer, default: 0
    field :id, :integer, primary_key: true
    belongs_to :character, Dsa.Characters.Character, primary_key: true
  end

  def changeset(prayer, params \\ %{}) do
    prayer
    |> cast(params, [:character_id, :id, :level])
    |> validate_required([:character_id, :id])
    |> validate_number(:id, greater_than: 0, less_than_or_equal_to: count())
    |> validate_number(:level, greater_than_or_equal_to: 0)

    |> foreign_key_constraint(:character_id)
    |> unique_constraint([:character_id, :spell_id])
  end

  def count, do: 40
  def list, do: :ets.tab2list(@table)
  def get(id), do: List.first(:ets.lookup(@table, id))

  def options(c) do
    character_prayer_ids = Enum.map(c.spells, & &1.id)

    1..count()
    |> Enum.reject(& Enum.member?(character_prayer_ids, &1))
    |> Enum.map(& {name(&1), &1})
  end

  def sf(id), do: :ets.lookup_element(@table, id, 2)
  def probe(id), do: :ets.lookup_element(@table, id, 3)
  def name(id), do: :ets.lookup_element(@table, id, 4)
  def traditions(id), do: :ets.lookup_element(@table, id, 5)

  def tooltip(_id) do
    ~E"""
    <p class="small mb-1">TODO</p>
    """
  end

  def seed do
    :ets.new(@table , [:ordered_set, :protected, :named_table])
    :ets.insert(@table, [
      # {id, sf, probe, name, traditions}
      {1, "B", "MU/KL/IN", "Ackersegen", [7]},
      {2, "A", "MU/KL/CH", "Bann der Dunkelheit", [9]},
      {3, "B", "IN/CH/CH", "Bann der Furcht", [5]},
      {4, "B", "MU/KL/CH", "Bann des Lichts", [5, 8]},
      {5, "A", "MU/KL/IN", "Blendstrahl", [9]},
      {6, "B", "MU/IN/CH", "Ehrenhaftigkeit", [10]},
      {7, "A", "KL/KL/IN", "Entzifferung", [6]},
      {8, "B", "MU/IN/CH", "Ermutigung", [10]},
      {9, "B", "MU/IN/CH", "Exorzismus", [1, 5, 9]},
      {10, "A", "MU/IN/GE", "Fall ins Nichts", [8]},
      {11, "B", "MU/IN/CH", "Friedvolle Aura", [7, 6]},
      {12, "B", "MU/IN/CH", "Geweihter Panzer", [10]},
      {13, "B", "KL/IN/CH", "Giftbann", [7]},
      {14, "A", "KL/IN/IN", "Göttlicher Fingerzeig", [1]},
      {15, "A", "IN/IN/CH", "Göttliches Zeichen", [1]},
      {16, "B", "KL/IN/CH", "Heilsegen", [7]},
      {17, "B", "MU/MU/CH", "Kleiner Bann wider Untote", [5]},
      {18, "B", "MU/IN/CH", "Kleiner Bannstrahl", [9]},
      {19, "B", "KL/IN/CH", "Krankheitsbann", [7]},
      {20, "B", "IN/IN/GE", "Lautlos", [8]},
      {21, "B", "MU/KL/IN", "Löwengestalt", [10]},
      {22, "C", "MU/IN/CH", "Magieschutz", [6, 9]},
      {23, "A", "KL/IN/IN", "Magiesicht", [6, 9]},
      {24, "A", "KL/KL/IN", "Mondsicht", [8]},
      {25, "B", "KL/IN/CH", "Mondsilberzunge", [8]},
      {26, "B", "KL/IN/CH", "Nebelleib", [8]},
      {27, "B", "MU/IN/CH", "Objektsegen", [1]},
      {28, "C", "KL/IN/CH", "Objektweihe", [1]},
      {29, "A", "MU/KL/IN", "Ort der Ruhe", [5]},
      {30, "A", "KL/IN/CH", "Pflanzenwuchs", [7]},
      {31, "A", "MU/KL/IN", "Rabenruf", [5]},
      {32, "B", "KL/IN/CH", "Schlaf", [5]},
      {33, "B", "MU/KL/IN", "Schlangenstab", [6]},
      {34, "A", "MU/KL/IN", "Schlangenzunge", [6]},
      {35, "C", "MU/IN/KO", "Schmerzresistenz", [10]},
      {36, "B", "MU/IN/CH", "Schutz der Wehrlosen", [10]},
      {37, "A", "KL/IN/CH", "Sternenglanz", [8]},
      {38, "C", "MU/KL/IN", "Wahrheit", [9]},
      {39, "B", "IN/IN/GE", "Wieselflink", [8]},
      {40, "B", "KL/KL/IN", "Wundersame Verständigung", [6, 8]}
    ])
  end
end
