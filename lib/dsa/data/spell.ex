defmodule Dsa.Data.Spell do
  @moduledoc """
  CharacterCast module
  """
  use Ecto.Schema
  use Phoenix.HTML
  import Ecto.Changeset

  @table :spells

  @primary_key false
  schema "spells" do
    field :level, :integer, default: 0
    field :id, :integer, primary_key: true
    belongs_to :character, Dsa.Accounts.Character, primary_key: true
  end

  def changeset(spell, params \\ %{}) do
    spell
    |> cast(params, [:character_id, :id, :level])
    |> validate_required([:character_id, :id])
    |> validate_number(:id, greater_than: 0, less_than_or_equal_to: count())
    |> validate_number(:level, greater_than_or_equal_to: 0)

    |> foreign_key_constraint(:character_id)
    |> unique_constraint([:character_id, :spell_id])
  end

  def count, do: 51
  def list, do: :ets.tab2list(@table)
  def get(id), do: List.first(:ets.lookup(@table, id))

  def options(c) do
    character_spell_ids = Enum.map(c.spells, & &1.id)

    1..count()
    |> Enum.reject(& Enum.member?(character_spell_ids, &1))
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
      {1, "B", "KL/IN/FF", "Adlerauge", [3]},
      {2, "D", "KL/IN/FF", "Arcanovi", [1]},
      {3, "C", "KL/KL/IN", "Analys Arkanstruktur", [1]},
      {4, "C", "KL/IN/FF", "Armatrutz", [1]},
      {5, "B", "KL/IN/FF", "Axxeleratus", [3]},
      {6, "B", "KL/IN/FF", "Balsam Salabunde", [1]},
      {7, "B", "MU/IN/CH", "Bannbaladin", [1]},
      {8, "C", "MU/KL/IN", "Blick in die Gedanken", [1]},
      {9, "A", "MU/IN/CH", "Blitz dich find", [1]},
      {10, "C", "KL/IN/KO", "Corpofesso", [2]},
      {11, "B", "MU/KL/CH", "Disruptivo", [1]},
      {12, "C", "MU/CH/KO", "Dschinnenruf", [2]},
      {13, "C", "KL/IN/CH", "Duplicatus", [2]},
      {14, "B", "MU/CH/KO", "Elementarer Diener", [2]},
      {15, "B", "MU/KL/IN", "Falkenauge", [3]},
      {16, "A", "MU/KL/CH", "Flim Flam", [1]},
      {17, "C", "KL/IN/KO", "Fulminictus", [3]},
      {18, "B", "MU/KL/CH", "Gardianum", [2]},
      {19, "B", "MU/IN/CH", "Große Gier", [4]},
      {20, "B", "KL/IN/CH", "Harmlose Gestalt", [4]},
      {21, "B", "KL/IN/KO", "Hexengalle", [4]},
      {22, "A", "KL/IN/KO", "Hexenkrallen", [4]},
      {23, "B", "MU/IN/CH", "Horriphobus", [2]},
      {24, "C", "MU/KL/CH", "Ignifaxius", [2]},
      {25, "C", "MU/CH/KO", "Invocatio Maior", [2, 4]},
      {26, "A", "MU/CH/KO", "Invocatio Minima", [2, 4]},
      {27, "B", "MU/CH/KO", "Invocatio Minor", [2, 4]},
      {28, "A", "KL/IN/KO", "Katzenaugen", [4]},
      {29, "A", "KL/IN/KO", "Krötensprung", [4]},
      {30, "A", "MU/KL/CH", "Manifesto", [1]},
      {31, "A", "KL/FF/KK", "Manus Miracula", [1]},
      {32, "B", "KL/FF/KK", "Motoricus", [1]},
      {33, "C", "MU/KL/CH", "Nebelwand", [3]},
      {34, "B", "KL/IN/CH", "Oculus Illusionis", [2]},
      {35, "A", "KL/IN/IN", "Odem Arcanum", [1]},
      {36, "B", "KL/IN/KO", "Paralysis", [2]},
      {37, "B", "MU/KL/IN", "Penetrizzel", [2]},
      {38, "B", "KL/IN/FF", "Psychostabilis", [1]},
      {39, "B", "KL/FF/KK", "Radau", [4]},
      {40, "B", "MU/IN/CH", "Respondami", [2]},
      {41, "C", "KL/IN/KO", "Salander", [2]},
      {42, "A", "MU/IN/CH", "Sanftmut", [4]},
      {43, "B", "KL/IN/KO", "Satuarias Herrlichkeit", [4]},
      {44, "B", "KL/FF/KK", "Silentium", [3]},
      {45, "B", "MU/IN/CH", "Somnigravis", [3]},
      {46, "A", "KL/IN/KO", "Spinnenlauf", [4]},
      {47, "B", "KL/FF/KK", "Spurlos", [3]},
      {48, "C", "MU/CH/KO", "Transversalis", [2]},
      {49, "B", "KL/IN/KO", "Visibili", [3]},
      {50, "B", "KL/IN/KO", "Wasseratem", [3]},
      {51, "D", "KL/IN/FF", "Zauberklinge Geisterspeer", [1]}
    ])
  end
end
