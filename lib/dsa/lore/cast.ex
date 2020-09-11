defmodule Dsa.Lore.Cast do
  use Ecto.Schema

  import Ecto.Changeset
  import Dsa.Lists

  schema "casts" do
    field :name, :string
    field :type, :integer
    field :e1, :string
    field :e2, :string
    field :e3, :string
    field :sf, :string

    many_to_many :traditions, Dsa.Lore.Tradition, join_through: "tradition_casts", on_replace: :delete

    many_to_many :characters, Dsa.Accounts.Character,
      join_through: Dsa.Accounts.CharacterCast,
      on_replace: :delete
  end

  @fields ~w(name type e1 e2 e3 sf)a
  def changeset(skill, attrs) do
    skill
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> validate_length(:name, max: 30)
    |> validate_number(:type, greater_than_or_equal_to: 1, less_than_or_equal_to: 4)
    |> validate_inclusion(:e1, base_value_options())
    |> validate_inclusion(:e2, base_value_options())
    |> validate_inclusion(:e3, base_value_options())
    |> validate_inclusion(:sf, sf_values())
    |> unique_constraint(:name)
  end

  def entries do
    [
      # Zaubersprüche (1)
      {1, "B", "KL/IN/FF", "Adlerauge", ["Elf"]},
      {1, "C", "KL/KL/IN", "Analys Arkanstruktur", ["Allgemein"]},
      {1, "C", "KL/IN/FF", "Armatrutz", ["Allgemein"]},
      {1, "B", "KL/IN/FF", "Axxeleratus", ["Elf"]},
      {1, "B", "KL/IN/FF", "Balsam Salabunde", ["Allgemein"]},
      {1, "B", "MU/IN/CH", "Bannbaladin", ["Allgemein"]},
      {1, "C", "MU/KL/IN", "Blick in die Gedanken", ["Allgemein"]},
      {1, "A", "MU/IN/CH", "Blitz dich find", ["Allgemein"]},
      {1, "C", "KL/IN/KO", "Corpofesso", ["Gildenmagier"]},
      {1, "B", "MU/KL/CH", "Disruptivo", [""]},
      {1, "C", "KL/IN/CH", "Duplicatus", ["Gildenmagier"]},
      {1, "B", "MU/KL/IN", "Falkenauge", ["Elf"]},
      {1, "A", "MU/KL/CH", "Flim Flam", ["Allgemein"]},
      {1, "C", "KL/IN/KO", "Fulminictus", ["Elf"]},
      {1, "B", "MU/KL/CH", "Gardianum", ["Gildenmagier"]},
      {1, "B", "MU/IN/CH", "Große Gier", ["Hexe"]},
      {1, "B", "KL/IN/CH", "Harmlose Gestalt", ["Hexe"]},
      {1, "B", "KL/IN/KO", "Hexengalle", ["Hexe"]},
      {1, "A", "KL/IN/KO", "Hexenkrallen", ["Hexe"]},
      {1, "B", "MU/IN/CH", "Horriphobus", ["Gildenmagier"]},
      {1, "C", "MU/KL/CH", "Ignifaxius", ["Gildenmagier"]},
      {1, "A", "MU/CH/KO", "Invocatio Minima", ["Gildenmagier", "Hexe"]},
      {1, "A", "KL/IN/KO", "Katzenaugen", ["Hexe"]},
      {1, "A", "KL/IN/KO", "Krötensprung", ["Hexe"]},
      {1, "A", "MU/KL/CH", "Manifesto", ["Allgemein"]},
      {1, "A", "KL/FF/KK", "Manus Miracula", ["Allgemein"]},
      {1, "B", "KL/FF/KK", "Motoricus", ["Allgemein"]},
      {1, "C", "MU/KL/CH", "Nebelwand", ["Elf"]},
      {1, "B", "KL/IN/CH", "Oculus Illusionis", ["Gildenmagier"]},
      {1, "A", "KL/IN/IN", "Odem Arcanum", ["Allgemein"]},
      {1, "B", "KL/IN/KO", "Paralysis", ["Gildenmagier"]},
      {1, "B", "MU/KL/IN", "Penetrizzel", ["Gildenmagier"]},
      {1, "B", "KL/IN/FF", "Psychostabilis", ["Allgemein"]},
      {1, "B", "KL/FF/KK", "Radau", ["Hexe"]},
      {1, "B", "MU/IN/CH", "Respondami", ["Gildenmagier"]},
      {1, "C", "KL/IN/KO", "Salander", ["Gildenmagier"]},
      {1, "A", "MU/IN/CH", "Sanftmut", ["Hexe"]},
      {1, "B", "KL/IN/KO", "Satuarias Herrlichkeit", ["Hexe"]},
      {1, "B", "KL/FF/KK", "Silentium", ["Elf"]},
      {1, "B", "MU/IN/CH", "Somnigravis", ["Elf"]},
      {1, "A", "KL/IN/KO", "Spinnenlauf", ["Hexe"]},
      {1, "B", "KL/FF/KK", "Spurlos", ["Elf"]},
      {1, "C", "MU/CH/KO", "Transversalis", ["Gildenmagier"]},
      {1, "B", "KL/IN/KO", "Visibili", ["Elf"]},
      {1, "B", "KL/IN/KO", "Wasseratem", ["Elf"]},
      # Rituale (2)
      {2, "D", "KL/IN/FF", "Arcanovi", ["Allgemein"]},
      {2, "C", "MU/CH/KO", "Dschinnenruf", ["Gildenmagier"]},
      {2, "B", "MU/CH/KO", "Elementarer Diener", ["Gildenmagier"]},
      {2, "C", "MU/CH/KO", "Invocatio Maior", ["Gildenmagier", "Hexe"]},
      {2, "B", "MU/CH/KO", "Invocatio Minor", ["Gildenmagier", "Hexe"]},
      {2, "D", "KL/IN/FF", "Zauberklinge Geisterspeer", ["Allgemein"]},
      # Liturgien (3)
      {3, "A", "MU/KL/CH", "Bann der Dunkelheit", ["Praioskirche"]},
      {3, "B", "IN/CH/CH", "Bann der Furcht", ["Boronkirche"]},
      {3, "B", "MU/KL/CH", "Bann des Lichts", ["Boronkirche", "Phexkirche"]},
      {3, "A", "MU/KL/IN", "Blendstrahl", ["Praioskirche"]},
      {3, "B", "MU/IN/CH", "Ehrenhaftigkeit", ["Rondrakirche"]},
      {3, "A", "KL/KL/IN", "Entzifferung", ["Hesindekirche"]},
      {3, "B", "MU/IN/CH", "Ermutigung", ["Rondrakirche"]},
      {3, "A", "MU/IN/GE", "Fall ins Nichts", ["Phexkirche"]},
      {3, "B", "MU/IN/CH", "Friedvolle Aura", ["Perainekirche", "Hesindekirche"]},
      {3, "B", "KL/IN/CH", "Giftbann", ["Perainekirche"]},
      {3, "A", "KL/IN/IN", "Göttlicher Fingerzeig", ["Allgemein"]},
      {3, "A", "IN/IN/CH", "Göttliches Zeichen", ["Allgemein"]},
      {3, "B", "KL/IN/CH", "Heilsegen", ["Perainekirche"]},
      {3, "B", "MU/MU/CH", "Kleiner Bann wider Untote", ["Boronkirche"]},
      {3, "B", "MU/IN/CH", "Kleiner Bannstrahl", ["Praioskirche"]},
      {3, "B", "KL/IN/CH", "Krankheitsbann", ["Perainekirche"]},
      {3, "B", "IN/IN/GE", "Lautlos", ["Phexkirche"]},
      {3, "C", "MU/IN/CH", "Magieschutz", ["Hesindekirche", "Praioskirche"]},
      {3, "A", "KL/IN/IN", "Magiesicht", ["Hesindekirche", "Praioskirche"]},
      {3, "A", "KL/KL/IN", "Mondsicht", ["Phexkirche"]},
      {3, "B", "KL/IN/CH", "Mondsilberzunge", ["Phexkirche"]},
      {3, "B", "MU/IN/CH", "Objektsegen", ["Allgemein"]},
      {3, "A", "MU/KL/IN", "Ort der Ruhe", ["Boronkirche"]},
      {3, "A", "KL/IN/CH", "Pflanzenwuchs", ["Perainekirche"]},
      {3, "A", "MU/KL/IN", "Rabenruf", ["Boronkirche"]},
      {3, "B", "KL/IN/CH", "Schlaf", ["Boronkirche"]},
      {3, "B", "MU/KL/IN", "Schlangenstab", ["Hesindekirche"]},
      {3, "A", "MU/KL/IN", "Schlangenzunge", ["Hesindekirche"]},
      {3, "C", "MU/IN/KO", "Schmerzresistenz", ["Rondrakirche"]},
      {3, "B", "MU/IN/CH", "Schutz der Wehrlosen", ["Rondrakirche"]},
      {3, "A", "KL/IN/CH", "Sternenglanz", ["Phexkirche"]},
      {3, "C", "MU/KL/IN", "Wahrheit", ["Praioskirche"]},
      {3, "B", "IN/IN/GE", "Wieselflink", ["Phexkirche"]},
      {3, "B", "KL/KL/IN", "Wundersame Verständigung", ["Hesindekirche", "Phexkirche"]},
      # Zeremonien (4)
      {4, "B", "MU/KL/IN", "Ackersegen", ["Perainekirche"]},
      {4, "B", "MU/IN/CH", "Exorzismus", ["Allgemein", "Boronkirche", "Praioskirche"]},
      {4, "B", "MU/IN/CH", "Geweihter Panzer", ["Rondrakirche"]},
      {4, "B", "MU/KL/IN", "Löwengestalt", ["Rondrakirche"]},
      {4, "B", "KL/IN/CH", "Nebelleib", ["Phexkirche"]},
      {4, "C", "KL/IN/CH", "Objektweihe", ["Allgemein"]}
    ]
    |> Enum.map(fn {type, sf, probe, name, traditions} ->
      [e1, e2, e3] = String.split(probe, "/")
      %{name: name, sf: sf, e1: e1, e2: e2, e3: e3, type: type, traditions: traditions}
    end)
  end
end
