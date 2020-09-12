defmodule Dsa.Data do
  use GenServer

  @name __MODULE__

  @traditions [
    #  {id, magic, le, name, ap}
    {1, nil, nil, "Allgemein", nil},
    # Zauberertraditionen
    {2, true, "KL", "Gildenmagier", 155},
    {3, true, "IN", "Elfen", 125},
    {4, true, "CH", "Hexen", 135},
    # Geweihtentraditionen
    {5, false, "MU", "Boronkirche", 130},
    {6, false, "KL", "Hesindekirche", 130},
    {7, false, "IN", "Perainekirche", 110},
    {8, false, "IN", "Phexkirche", 150},
    {9, false, "KL", "Praioskirche", 130},
    {10, false, "MU", "Rondrakirche", 150}
  ]

  @spells [
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
  ]

  @prayers [
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
  ]

  def start_link(_), do: GenServer.start_link(__MODULE__, [], name: @name)

  def init(_) do
    :ets.new(:prayers, [:ordered_set, :protected, :named_table])
    :ets.insert(:prayers, @prayers)

    :ets.new(:spells, [:ordered_set, :protected, :named_table])
    :ets.insert(:spells, @spells)

    :ets.new(:traditions, [:ordered_set, :protected, :named_table])
    :ets.insert(:traditions, @traditions)

    {:ok, "In-Memory Database created and filled."}
  end

  # Prayers
  def prayers, do: :ets.tab2list(:prayers)

  def prayer_options() do
    Enum.map(prayers(), fn {id, _sf, _probe, name, _traditions} -> {name, id} end)
  end

  def prayer(id, :name), do: :ets.lookup_element(:prayers, id, 4)
  def prayer(id, :probe), do: :ets.lookup_element(:prayers, id, 3)
  def prayer(id, :sf), do: :ets.lookup_element(:prayers, id, 4)

  def valid_prayer?(id), do: :ets.member(:prayer, id)

  # Spells
  def spells, do: :ets.tab2list(:spells)

  def spell_options() do
    Enum.map(spells(), fn {id, _sf, _probe, name, _traditions} -> {name, id} end)
  end

  def spell(id, :name), do: :ets.lookup_element(:spells, id, 4)
  def spell(id, :probe), do: :ets.lookup_element(:spells, id, 3)
  def spell(id, :sf), do: :ets.lookup_element(:spells, id, 2)

  def valid_spell?(id), do: :ets.member(:spells, id)

  # Traditions

  def traditions, do: :ets.tab2list(:traditions)

  def tradition(id) do
    case :ets.lookup(:traditions, id) do
      [] -> nil
      [data] -> data
    end
  end

  def tradition(nil, _), do: nil
  def tradition(id, :ap), do: :ets.lookup_element(:traditions, id, 5)
  def tradition(id, :le), do: :ets.lookup_element(:traditions, id, 3)
  def tradition(id, :name), do: :ets.lookup_element(:traditions, id, 4)

  def tradition_options(:magic) do
    traditions()
    |> Enum.filter(fn {_id, magic, _le, _name, _ap} -> magic end)
    |> Enum.map(fn {id, _magic, _le, name, _ap} -> {name, id} end)
  end

  def tradition_options(:karmal) do
    traditions()
    |> Enum.filter(fn {_id, magic, _le, _name, _ap} -> magic == false end)
    |> Enum.map(fn {id, _magic, _le, name, _ap} -> {name, id} end)
  end
end
