defmodule Dsa.Lore.Trait do
  use Ecto.Schema

  import Ecto.Changeset

  schema "traits" do
    field :level, :integer  # 0 - general skill, 1+ advantage/disadvantage
    field :ap, :integer
    field :details, :boolean, default: false
    field :fixed_ap, :boolean, default: true
    field :name, :string
  end

  @fields ~w(level name ap details fixed_ap)a
  def changeset(skill, attrs) do
    skill
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> validate_number(:level, greater_than_or_equal_to: 0)
    |> validate_number(:ap, not_equal_to: 0)
    |> unique_constraint(:name)
  end

  def entries do
    [
      # Vorteile Basiswerk
      {3, "Adel", 5, true, true},
      {1, "Altersresistenz", 5, false, true},
      {1, "Angenehmer Geruch", 6, false, true},
      {1, "Begabung", 6, true, false},
      {1, "Beidhändig", 15, false, true},
      {2, "Dunkelsicht", 10, false, true},
      {1, "Eisenaffine Aura", 15, false, true},
      {1, "Entfernungssinn", 10, false, true},
      {1, "Flink", 8, false, true},
      {1, "Fuchssinn", 15, false, true},
      {1, "Geborener Redner", 4, false, true},
      {1, "Geweihter", 25, false, true},
      {2, "Giftresistenz", 10, false, true},
      {3, "Glück", 30, false, true},
      {2, "Gutaussehend", 20, false, true},
      {1, "Herausragende Fertigkeit", 2, true, false},
      {1, "Herausragende Kampftechnik", 8, true, false},
      {1, "Herausragender Sinn", 2, true, false},
      {1, "Hitzeresistenz", 5, false, true},
      {7, "Hohe Astralkraft", 6, false, true},
      {7, "Hohe Karmalkraft", 6, false, true},
      {7, "Hohe Lebenskraft", 6, false, true},
      {1, "Hohe Seelenkraft", 25, false, true},
      {1, "Hohe Zähigkeit", 25, false, true},
      {1, "Immunität gegen (Gift)", 25, true, false},
      {1, "Immunität gegen (Krankheit)", 25, true, false},
      {1, "Kälteresistenz", 5, false, true},
      {2, "Krankheitsresistenz", 10, false, true},
      {1, "Magische Einstimmung", 40, true, false},
      {1, "Mystiker", 20, false, true},
      {1, "Nichtschläfer", 8, false, true},
      {1, "Pragmatiker", 10, false, true},
      {10, "Reich", 1, false, true},
      {1, "Richtungssinn", 10, false, true},
      {1, "Schlangenmensch", 6, false, true},
      {1, "Schwer zu verzaubern", 15, false, true},
      {1, "Soziale Anpassungsfähigkeit", 10, false, true},
      {1, "Unscheinbar", 4, false, true},
      {3, "Verbesserte Regeneration (Astralenergie)", 10, false, true},
      {3, "Verbesserte Regeneration (Karmaenergie))", 10, false, true},
      {3, "Verbesserte Regeneration (Lebensenergie))", 10, false, true},
      {1, "Verhüllte Aura", 20, false, true},
      {1, "Vertrauenerweckend", 25, false, true},
      {1, "Waffenbegabung", 5, true, false},
      {1, "Wohlklang", 5, false, true},
      {1, "Zäher Hund", 20, false, true},
      {1, "Zauberer", 25, false, true},
      {1, "Zeitgefühl", 2, false, true},
      {1, "Zweistimmiger Gesang", 5, false, true},
      {1, "Zwergennase", 8, false, true},
      # Nachteile Basisregelwerk
      {3, "Angst vor", -8, true, true},
      {3, "Arm", -1, false, true},
      {1, "Artefaktgebunden", -10, false, true},
      {1, "Behäbig", -4, false, true},
      {1, "Blind", -50, false, true},
      {1, "Blutrausch", -10, false, true},
      {1, "Eingeschränkter Sinn", -2, true, false},
      {1, "Farbenblind", -2, false, true},
      {1, "Fettleibig", -25, false, true},
      {2, "Giftanfällig", -5, false, true},
      {2, "Hässlich", -10, false, true},
      {1, "Hitzeempfindlich", -3, false, true},
      {1, "Kälteempfindlich", -3, false, true},
      {1, "Keine Flugsalbe", -25, false, true},
      {1, "Kein Vertrauter", -25, false, true},
      {1, "Körpergebundene Kraft", -5, false, true},
      {1, "Körperliche Auffälligkeit", -2, true, true},
      {2, "Krankheitsanfällig", -5, false, true},
      {1, "Lästige Mindergeister", -20, false, true},
      {1, "Lichtempfindlich", -20, false, true},
      {1, "Magische Einschränkung", -30, true, true},
      {1, "Nachtblind", -10, false, true},
      {7, "Niedrige Astralkraft", -2, false, true},
      {7, "Niedrige Karmalkraft", -2, false, true},
      {7, "Niedrige Lebenskraft", -2, false, true},
      {1, "Niedrige Seelenkraft", -25, false, true},
      {1, "Niedrige Zähigkeit", -25, false, true},
      {3, "Pech", -20, false, true},
      {1, "Pechmagnet", -5, false, true},
      {1, "Persönlichkeitsschwächen", -5, true, false},
      {3, "Prinzipientreue", -10, true, true},
      {1, "Schlafwandler", -10, false, true},
      {1, "Schlechte Angewohnheit", -2, true, true},
      {1, "Schlechte Eigenschaft", -5, true, false},
      {3, "Schlechte Regeneration (Astralenergie)", -10, false, true},
      {3, "Schlechte Regeneration (Karmaenergie))", -10, false, true},
      {3, "Schlechte Regeneration (Lebensenergie))", -10, false, true},
      {1, "Schwacher Astralkörper", -15, false, true},
      {1, "Schwacher Karmalkörper", -15, false, true},
      {1, "Sensibler Geruchssinn", -10, false, true},
      {1, "Sprachfehler", -15, false, true},
      {1, "Stigma", -10, true, true},
      {1, "Stumm", -40, false, true},
      {1, "Taub", -40, false, true},
      {1, "Unfähig", -1, true, false},
      {1, "Unfrei", -8, false, true},
      {1, "Verpflichtungen", -10, true, true},
      {1, "Verstümmelt", -5, true, false},
      {1, "Wahrer Name", -10, false, true},
      {1, "Wilde Magie", -10, false, true},
      {2, "Zauberanfällig", -12, false, true},
      {1, "Zerbrechlich", -20, false, true},
      # Allgemeine Sonderfertigkeiten (Basisregelwerk)
      {0, "Analytiker", 5, false, true},
      {0, "Anführer", 10, false, true},
      {0, "Berufsgeheimnis", 1, true, false},
      {0, "Dokumentfälscher", 5, false, true},
      {0, "Eiserner Wille I", 15, false, true},
      {0, "Eiserner Wille II", 15, false, true},
      {0, "Fächersprache", 3, false, true},
      {0, "Fallen entschärfen", 5, false, true},
      {0, "Falschspielen", 5, false, true},
      {0, "Fertigkeitsspezialisierung (Talente)", 1, true, false},
      {0, "Fischer", 3, false, true},
      {0, "Füchsisch", 3, false, true},
      {0, "Geländekunde", 15, false, true},
      {0, "Gildenrecht", 2, false, true},
      {0, "Glasbläserei", 2, false, true},
      {0, "Hehlerei", 5, false, true},
      {0, "Heraldik", 2, false, true},
      {0, "Instrumente bauen", 2, false, true},
      {0, "Jäger", 5, false, true},
      {0, "Kartographie", 5, false, true},
      {0, "Lippenlesen", 10, false, true},
      {0, "Meister der Improvisation", 10, false, true},
      {0, "Ortskenntnis", 2, true, false},
      {0, "Rosstäuscher", 5, false, true},
      {0, "Sammler", 2, false, true},
      {0, "Schmerzen unterdrücken", 20, false, true},
      {0, "Schnapsbrennerei", 2, false, true},
      {0, "Schrift", 2, true, false},
      {0, "Schriftstellerei", 2, true, true},
      {0, "Sprache I", 2, true, true},
      {0, "Sprache II", 2, true, true},
      {0, "Sprache III", 6, true, true},
      {0, "Tierstimmen imitieren", 5, false, true},
      {0, "Töpferei", 2, false, true},
      {0, "Wettervorhersage", 2, false, true},
      {0, "Zahlenmystik", 2, false, true},
      # Schicksalspunkte Sonderfertigkeiten
      {0, "Attacke verbessern", 5, false, true},
      {0, "Ausweichen verbessern", 5, false, true},
      {0, "Eigenschaft verbessern", 5, false, true},
      {0, "Fernkampf verbessern", 5, false, true},
      {0, "Parade verbessern", 5, false, true},
      {0, "Wachsamkeit verbessern", 10, false, true}
    ]
    |> Enum.map(fn {level, name, ap, details, fixed_ap} ->
      %{name: name, ap: ap, level: level, fixed_ap: fixed_ap, details: details}
    end)
  end
end
