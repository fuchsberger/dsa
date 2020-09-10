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
      {1, "B", "KL/IN/FF", "Adlerauge"},
      {1, "C", "KL/KL/IN", "Analys Arkanstruktur"},
      {1, "C", "KL/IN/FF", "Armatrutz"},
      {1, "B", "KL/IN/FF", "Axxeleratus"},
      {1, "B", "KL/IN/FF", "Balsam Salabunde"},
      {1, "B", "MU/IN/CH", "Bannbaladin"},
      {1, "C", "MU/KL/IN", "Blick in die Gedanken"},
      {1, "A", "MU/IN/CH", "Blitz dich find"},
      {1, "C", "KL/IN/KO", "Corpofesso"},
      {1, "B", "MU/KL/CH", "Disruptivo"},
      {1, "C", "KL/IN/CH", "Duplicatus"},
      {1, "B", "MU/KL/IN", "Falkenauge"},
      {1, "A", "MU/KL/CH", "Flim Flam"},
      {1, "C", "KL/IN/KO", "Fulminictus"},
      {1, "B", "MU/KL/CH", "Gardianum"},
      {1, "B", "MU/IN/CH", "Große Gier"},
      {1, "B", "KL/IN/CH", "Harmlose Gestalt"},
      {1, "B", "KL/IN/KO", "Hexengalle"},
      {1, "A", "KL/IN/KO", "Hexenkrallen"},
      {1, "B", "MU/IN/CH", "Horriphobus"},
      {1, "C", "MU/KL/CH", "Ignifaxius"},
      {1, "A", "MU/CH/KO", "Invocatio Minima"},
      {1, "A", "KL/IN/KO", "Katzenaugen"},
      {1, "A", "KL/IN/KO", "Krötensprung"},
      {1, "A", "MU/KL/CH", "Manifesto"},
      {1, "A", "KL/FF/KK", "Manus Miracula"},
      {1, "B", "KL/FF/KK", "Motoricus"},
      {1, "C", "MU/KL/CH", "Nebelwand"},
      {1, "B", "KL/IN/CH", "Oculus Illusionis"},
      {1, "A", "KL/IN/IN", "Odem Arcanum"},
      {1, "B", "KL/IN/KO", "Paralysis"},
      {1, "B", "MU/KL/IN", "Penetrizzel"},
      {1, "B", "KL/IN/FF", "Psychostabilis"},
      {1, "B", "KL/FF/KK", "Radau"},
      {1, "B", "MU/IN/CH", "Respondami"},
      {1, "C", "KL/IN/KO", "Salander"},
      {1, "A", "MU/IN/CH", "Sanftmut"},
      {1, "B", "KL/IN/KO", "Satuarias Herrlichkeit"},
      {1, "B", "KL/FF/KK", "Silentium"},
      {1, "B", "MU/IN/CH", "Somnigravis"},
      {1, "A", "KL/IN/KO", "Spinnenlauf"},
      {1, "B", "KL/FF/KK", "Spurlos"},
      {1, "C", "MU/CH/KO", "Transversalis"},
      {1, "B", "KL/IN/KO", "Visibili"},
      {1, "B", "KL/IN/KO", "Wasseratem"},
      # Rituale (2)
      {2, "D", "KL/IN/FF", "Arcanovi"},
      {2, "C", "MU/CH/KO", "Dschinnenruf"},
      {2, "B", "MU/CH/KO", "Elementarer Diener"},
      {2, "C", "MU/CH/KO", "Invocatio Maior"},
      {2, "B", "MU/CH/KO", "Invocatio Minor"},
      {2, "D", "KL/IN/FF", "Zauberklinge Geisterspeer"},
      # Liturgien (3)
      {3, "A", "MU/KL/CH", "Bann der Dunkelheit"},
      {3, "B", "IN/CH/CH", "Bann der Furcht"},
      {3, "B", "MU/KL/CH", "Bann des Lichts"},
      {3, "A", "MU/KL/IN", "Blendstrahl"},
      {3, "B", "MU/IN/CH", "Ehrenhaftigkeit"},
      {3, "A", "KL/KL/IN", "Entzifferung"},
      {3, "B", "MU/IN/CH", "Ermutigung"},
      {3, "A", "MU/IN/GE", "Fall ins Nichts"},
      {3, "B", "MU/IN/CH", "Friedvolle Aura"},
      {3, "B", "KL/IN/CH", "Giftbann"},
      {3, "A", "KL/IN/IN", "Göttlicher Fingerzeig"},
      {3, "A", "IN/IN/CH", "Göttliches Zeichen"},
      {3, "B", "KL/IN/CH", "Heilsegen"},
      {3, "B", "MU/MU/CH", "Kleiner Bann wider Untote"},
      {3, "B", "MU/IN/CH", "Kleiner Bannstrahl"},
      {3, "B", "KL/IN/CH", "Krankheitsbann"},
      {3, "B", "IN/IN/GE", "Lautlos"},
      {3, "C", "MU/IN/CH", "Magieschutz"},
      {3, "A", "KL/IN/IN", "Magiesicht"},
      {3, "A", "KL/KL/IN", "Mondsicht"},
      {3, "B", "KL/IN/CH", "Mondsilberzunge"},
      {3, "B", "MU/IN/CH", "Objektsegen"},
      {3, "A", "MU/KL/IN", "Ort der Ruhe"},
      {3, "A", "KL/IN/CH", "Pflanzenwuchs"},
      {3, "A", "MU/KL/IN", "Rabenruf"},
      {3, "B", "KL/IN/CH", "Schlaf"},
      {3, "B", "MU/KL/IN", "Schlangenstab"},
      {3, "A", "MU/KL/IN", "Schlangenzunge"},
      {3, "C", "MU/IN/KO", "Schmerzresistenz"},
      {3, "B", "MU/IN/CH", "Schutz der Wehrlosen"},
      {3, "A", "KL/IN/CH", "Sternenglanz"},
      {3, "C", "MU/KL/IN", "Wahrheit"},
      {3, "B", "IN/IN/GE", "Wieselflink"},
      {3, "B", "KL/KL/IN", "Wundersame Verständigung"},
      # Zeremonien (4)
      {4, "B", "MU/KL/IN", "Ackersegen"},
      {4, "B", "MU/IN/CH", "Exorzismus"},
      {4, "B", "MU/IN/CH", "Geweihter Panzer"},
      {4, "B", "MU/KL/IN", "Löwengestalt"},
      {4, "B", "KL/IN/CH", "Nebelleib"},
      {4, "C", "KL/IN/CH", "Objektweihe"}
    ]
    |> Enum.map(fn {type, sf, probe, name} ->
      [e1, e2, e3] = String.split(probe, "/")
      %{name: name, sf: sf, e1: e1, e2: e2, e3: e3, type: type}
    end)
  end
end
