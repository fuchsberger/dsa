defmodule Dsa.Data.BlessingSeeds do
  alias Dsa.Data

  defp to_map({id, sf, t1, t2, t3, ceremony, cast_time, cost, name }) do
    %{
      id: id,
      sf: sf,
      t1: t1,
      t2: t2,
      t3: t3,
      ceremony: ceremony,
      cast_time: cast_time,
      cost: cost,
      name: name
    }
  end

  @blessings [
    # {id, sf, t1, t2, t3, ceremony, cast_time, cost, name, traditions}
    {1, :B, :mu, :kl, :in, true, 120, 16, "Ackersegen"},
    {2, :A, :mu, :kl, :ch, false, 1, 4, "Bann der Dunkelheit"},
    {3, :B, :in, :ch, :ch, false, 2, 8, "Bann der Furcht"},
    {4, :B, :mu, :kl, :ch, false, 4, 16, "Bann des Lichts"},
    {5, :A, :mu, :kl, :in, false, 1, 4, "Blendstrahl"},
    {6, :B, :mu, :in, :ch, false, 4, 8, "Ehrenhaftigkeit"},
    {7, :A, :kl, :kl, :in, false, 8, 4, "Entzifferung"},
    {8, :B, :mu, :in, :ch, false, 4, 8, "Ermutigung"},
    {9, :B, :mu, :in, :ch, true, 480, 32, "Exorzismus"},
    {10, :A, :mu, :in, :ge, false, 1, 8, "Fall ins Nichts"},
    {11, :B, :mu, :in, :ch, false, 1, 8, "Friedvolle Aura"},
    {12, :B, :mu, :in, :ch, true, 30, 16, "Geweihter Panzer"},
    {13, :B, :kl, :in, :ch, false, 4, 2, "Giftbann"},
    {14, :A, :kl, :in, :in, false, 4, 8, "Göttlicher Fingerzeig"},
    {15, :A, :in, :in, :ch, false, 4, 4, "Göttliches Zeichen"},
    {16, :B, :kl, :in, :ch, false, 16, 4, "Heilsegen"},
    {17, :B, :mu, :mu, :ch, false, 1, 4, "Kleiner Bann wider Untote"},
    {18, :B, :mu, :in, :ch, false, 2, 8, "Kleiner Bannstrahl"},
    {19, :B, :kl, :in, :ch, false, 16, 2, "Krankheitsbann"},
    {20, :B, :in, :in, :ge, false, 4, 4, "Lautlos"},
    {21, :B, :mu, :kl, :in, true, 30, 16, "Löwengestalt"},
    {22, :C, :mu, :in, :ch, false, 4, 8, "Magieschutz"},
    {23, :A, :kl, :in, :in, false, 2, 4, "Magiesicht"},
    {24, :A, :kl, :kl, :in, false, 4, 2, "Mondsicht"},
    {25, :B, :kl, :in, :ch, false, 1, 8, "Mondsilberzunge"},
    {26, :B, :kl, :in, :ch, true, 30, 16, "Nebelleib"},
    {27, :B, :mu, :in, :ch, false, 4, 4, "Objektsegen"},
    {28, :C, :kl, :in, :ch, true, 120, 16, "Objektweihe"},
    {29, :A, :mu, :kl, :in, false, 8, 4, "Ort der Ruhe"},
    {30, :A, :kl, :in, :ch, false, 16, 8, "Pflanzenwuchs"},
    {31, :A, :mu, :kl, :in, false, 16, 8, "Rabenruf"},
    {32, :B, :kl, :in, :ch, false, 2, 8, "Schlaf"},
    {33, :B, :mu, :kl, :in, false, 2, 8, "Schlangenstab"},
    {34, :A, :mu, :kl, :in, false, 8, 8, "Schlangenzunge"},
    {35, :C, :mu, :in, :ko, false, 1, 8, "Schmerzresistenz"},
    {36, :B, :mu, :in, :ch, false, 1, 8, "Schutz der Wehrlosen"},
    {37, :A, :kl, :in, :ch, false, 2, 8, "Sternenglanz"},
    {38, :C, :mu, :kl, :in, false, 8, 16, "Wahrheit"},
    {39, :B, :in, :in, :ge, false, 2, 8, "Wieselflink"},
    {40, :B, :kl, :kl, :in, false, 2, 8, "Wundersame Verständigung"}
  ]

  # def seed, do: Enum.each(@blessings, & Data.create_blessing!(to_map(&1)))

  def seed, do: nil

  def reseed do
    blessings = Data.list_blessings()

    Enum.each(@blessings, fn blessing ->
      attrs = to_map(blessing)

      IO.inspect(attrs)

      case Enum.find(blessings, &(&1.id == attrs.id)) do
        nil -> Data.create_blessing!(attrs)
        blessing -> Data.update_blessing!(blessing, attrs)
      end
    end)
  end
end
