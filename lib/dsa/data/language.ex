defmodule Dsa.Data.Language do
  use Ecto.Schema
  import Ecto.Changeset

  @table :languages

  @primary_key false
  schema "languages" do
    field :level, :integer, default: 1
    field :language_id, :integer, primary_key: true
    belongs_to :character, Dsa.Accounts.Character, primary_key: true
  end

  @fields ~w(character_id language_id level)a
  def changeset(language, params \\ %{}) do
    language
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_number(:level, greater_than_or_equal_to: 0, less_than_or_equal_to: 3)
    |> validate_number(:language_id, greater_than: 0, less_than_or_equal_to: count())
    |> foreign_key_constraint(:character_id)
    |> unique_constraint([:character_id, :language_id])
  end

  def count, do: :ets.info(@table, :size)
  def list, do: :ets.tab2list(@table)

  def options(changeset) do
    clanguages = get_field(changeset, :languages)
    list()
    |> Enum.map(fn {id, name, _dialects, _writings, _description} -> {name, id} end)
    |> Enum.reject(fn {_name, id} -> Enum.member?(Enum.map(clanguages, & &1.language_id), id) end)
  end

  def level(level) do
    case level do
      1 -> "I"
      2 -> "II"
      3 -> "III"
      0 -> "MS"
    end
  end

  def level_options, do: [{"MS", 0}, {"III", 3}, {"II", 2}, {"I", 1}]

  def name(id), do: :ets.lookup_element(@table, id, 2)

  def seed do
    :ets.new(@table , [:ordered_set, :protected, :named_table])
    :ets.insert(@table, [
      #{id, name, dialects, writings, description}
      {1, "Alaani", "Gajka, Takellen", "Kusliker Zeichen", "Die Sprachen der Norbarden, das Alaani, ist eine komplexe Weiterentwicklung aus dem Tulamidya."},
      {2, "Angram", nil, "Angram-Bilderschrift", "Unter den Zwergen wird nur noch selten und dann fast ausschließlich in der Angroschpriesterschaft das heilige Angram gesprochen."},
      {3, "Asdharia", "Shakagoran (Nachtalbisch, Mischsprache aus Asdharia, Rssahh und Zhayad)", "Isdira-Zeichen (deutlich verschnörkelter als die heutigen Isdira-Zeichen, bei Shakargoran auch Zhayad-Zeichen)", "Asdharia ist die alte Hochsprache der Elfen, die heute fast in Vergessenheit geraten ist. Aus ihr entwickelte sich das heutige Isdira. Anmerkung: Vorraussetzung, um die Sprache auf Stufe III zu sprechen, ist der Zweistimmige Gesang, den nur Elfen und Halbelfen beherrschen können."},
      {4, "Atak", "Tulamidisch, Güldenländisch", nil, "Zeichen- und Gebärdensprache, die vor allem von Gaunern, Dieben und Händlern gesprochen wird. Sie stammt ursprünglich aus den Tulamidenlanden, hat sich aber auch bei Phexanhängern in ganz Aventurien ausgebreitet."},
      {5, "Aureliani", nil, "Imperiale Zeichen", "Aureliani ist die Sprache der ersten güldenländischen Siedler Aventuriens und wird oft als Altgüldenländisch bezeichnet. Aus dieser Sprache entwickelten sich Bosparano und Zyklopäisch."},
      {6, "Bosporano", "Kirchenbosparano, Magierbosparano", "Imperiale Zeichen, später Kusliker Zeichen", "Bosparano wird heute fast nur noch von Geweihten, Magiern und Gelehrten gesprochen und war die Hochsprache des Alten Reiches. Gelegentlich wird Bosparano bei Gebeten verwendet."},
      {7, "Fjarningsch", "unterschiedliche Stammesdialekte", nil, "Abart des Saga-Thorwalschen, das von den Eisbarbaren des Nordens gesprochen wird."},
      {8, "Garethi", "Aretya, Horathi, Bornländisch, Brabaci, Maraskani, Alberned, Andergastisch, Charypto und Gatamo", "Kusliker Zeichen", "Garethi, welches aus dem Bosparano entstanden ist, ist die am weitesten verbreitete Sprache Aventuriens. Es wird in fast allen größeren mittelländischen Reichen gesprochen und ist die inoffizielle Gemeinsprache des Kontinents geworden."},
      {9, "Goblinisch", "unterschiedliche Stammesdialekte", nil, "Das Goblinische ist die einfache Sprache der Stammesgoblins."},
      {10, "Isdira", "nach Elfenvolk", "Isdira-Zeichen", "Das aus dem Asdharia entstandene Isdira ist die gemeinsame Sprache aller Elfenvölker Aventuriens. Anmerkung: Voraussetzung, um die Sprache auf Stufe III zu sprechen, ist der Zweistimmige Gesang, den nur Elfen und Halbelfen beherrschen können."},
      {11, "Mohisch", "unterschiedliche Stammesdialekte (z.B. Tocamuyac, Puka-Puka)", nil, "Die zahllosen Sprachen der Waldmenschen und Utulu sind einander sehr ähnlich. Gemeinhin wird die Sprache nach dem größten Stamm der Waldmenschen, den Mohaha, einfach Mohisch genannt."},
      {12, "Nujuka", "unterschiedliche Stammesdialekte", nil, "Nujuka, auch einfach nur Nivesisch genannt, ist die gemeinsame Sprache aller Nivesen."},
      {13, "Ogrisch", nil, nil, "Die Sprache der Oger ist sehr primitiv, oft erlernen die Menschenfresser noch einige Brocken einer Menschensprache oder Oloarkh. Ogrisch besitzt nur eine maximale Stufe von II."},
      {14, "Oloarkh", nil, nil, "Das Gemeinorkische wird nicht nur von den gewöhnlichen Orks, den ausgestoßenen Yurach, Orkräubern und Schwarzpelzen außerhalb des Orklands gesprochen, sondern auch von vielen Ogern und Goblins. Es ist eine vereinfachte Form des Hochorkischen (Ologhaijan). Oloarkh besitzt nur eine maximale Stufe von II."},
      {15, "Ologhaijan", "unterschiedliche Stammesdialekte", nil, "Ologhaijan ist die Hochsprache der Orks im Orkland. Sie wird vor allem von Häuptlingen, Kriegern und Schamanen gesprochen, andere Orks begnügen sich oft mit dem primitiveren Oloarkh."},
      {16, "Rabensprache", nil, nil, "Eine Geheimsprache, die vor allem unter al’anfanischen Borongeweihten verbreitet ist."},
      {17, "Rogolan", "nach Zwergenvolk", "Rogolan-Runen", "Sprache der Zwergenvölker Aventuriens"},
      {18, "Rssahh", "nach Echsenvolk", "Chrmk", "Die gemeinsame Verkehrssprache der echsischen Völker Aventuriens. Anmerkung: Falls man kein Echsenwesen ist, kann Rssahh nur bis zur Sprachstufe II erlernt werden."},
      {19, "Ruuz", nil, "Tulamidya (mittleres Tulamidya)", "Einst benutzten die Beni Rurech, die menschlichen Ursiedler der Insel Maraskan, das Ruuz. Heute wird es so gut wie nicht mehr gesprochen."},
      {20, "Saga-Thorwalsch", nil, "Hjaldingsche Runen", "Die Sprache wird auch als Hjaldingsch bezeichnet und findet heute vor allem in Lied- und Versform Verwendung."},
      {21, "Thorwalsch", "Nordthorwal, Südthorwal, Waskirer Hochland", "Thorwalsche Runen", "Die Sprache der Thorwaler, die sich aus dem Hjaldingsch (oder Saga-Thorwalsch) entwickelt hat."},
      {22, "Trollisch", "unterschiedliche Stammesdialekte", "Trollische Raumbilderschrift", "Das Trollische ist eine komplizierte Sprache der riesenhaften Trolle."},
      {23, "Tulamidya", "Aranisch, Khôm-Novadisch, Maraskani-Tulamidya, Mhanadisch-Balashidisch, Zahorisch", "Tulamidya oder Geheiligte Glyphen von Unau (bei den Novadis) oder Kusliker Zeichen (teilweise in Aranien)", "Neben dem Garethi ist das Tulamidya wohl die verbreitetste Sprache Aventuriens. Während das Tulamidya grundlegend die Tulamidya-Schriftzeichen verwendet, nutzen die Novadis vermehrt die Geheiligten Glyphen von Unau. Das Tulamidya entstammt der alten Sprache der Tulamiden, dem Ur-Tulamidya."},
      {24, "Ur-Tulamidya", "nach Region", "300 Wort- und Silbenzeichen des Ur-Tulamidya", "Das mittlerweile ausgestorbene Ur-Tulamidya war die Sprache der ersten Tulamiden und der ersten tulamidischen Hochkultur."},
      {25, "Zelemja", nil, "Chrmk", "In Selem und der näheren Umgebung spricht man das Zelemja, eine
      Mischsprache aus dem Rssahh der Echsenmenschen und dem Ur-Tulamidya. Das Zelemja ist uralt und mittlerweile fast ausgestorben."},
      {26, "Zhayad", nil, "Zhayad-Zeichen", "Bei Zhayad handelt es sich um eine Magiergeheimsprache, die vor allem bei Schwarzmagiern und Dämonenbeschwörern Verbreitung gefunden hat. Die Herkunft der Sprache ist unbekannt, aber man sagt ihr nach, dass sie aus den Niederhöllen stammen soll und alle Dämonen damit kommunizieren."},
      {27, "Zyklopäisch", nil, "Kusliker Zeichen, in einer alten Form Imperiale Zeichen", "Das Zyklopäische ist nicht die Sprache der einäugigen Riesen, sondern die der menschlichen Bewohner der Zyklopeninseln. Es hat sich aus dem Aureliani entwickelt und ist selbst auf den Zyklopeninseln eine kaum noch verwendete Sprache."}
    ])
  end
end
