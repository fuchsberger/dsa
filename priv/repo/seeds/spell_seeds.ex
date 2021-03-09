defmodule Dsa.Repo.Seeds.SpellSeeder do
  alias Dsa.Data
  require Logger

  @spells [
    {1, "B", :kl, :in, :ff, "Adlerauge", [3]},
    {2, "D", :kl, :in, :ff, "Arcanovi", [1]},
    {3, "C", :kl, :kl, :in, "Analys Arkanstruktur", [1]},
    {4, "C", :kl, :in, :ff, "Armatrutz", [1]},
    {5, "B", :kl, :in, :ff, "Axxeleratus", [3]},
    {6, "B", :kl, :in, :ff, "Balsam Salabunde", [1]},
    {7, "B", :mu, :in, :ch, "Bannbaladin", [1]},
    {8, "C", :mu, :kl, :in, "Blick in die Gedanken", [1]},
    {9, "A", :mu, :in, :ch, "Blitz dich find", [1]},
    {10, "C", :kl, :in, :ko, "Corpofesso", [2]},
    {11, "B", :mu, :kl, :ch, "Disruptivo", [1]},
    {12, "C", :mu, :ch, :ko, "Dschinnenruf", [2]},
    {13, "C", :kl, :in, :ch, "Duplicatus", [2]},
    {14, "B", :mu, :ch, :ko, "Elementarer Diener", [2]},
    {15, "B", :mu, :kl, :in, "Falkenauge", [3]},
    {16, "A", :mu, :kl, :ch, "Flim Flam", [1]},
    {17, "C", :kl, :in, :ko, "Fulminictus", [3]},
    {18, "B", :mu, :kl, :ch, "Gardianum", [2]},
    {19, "B", :mu, :in, :ch, "Große Gier", [4]},
    {20, "B", :kl, :in, :ch, "Harmlose Gestalt", [4]},
    {21, "B", :kl, :in, :ko, "Hexengalle", [4]},
    {22, "A", :kl, :in, :ko, "Hexenkrallen", [4]},
    {23, "B", :mu, :in, :ch, "Horriphobus", [2]},
    {24, "C", :mu, :kl, :ch, "Ignifaxius", [2]},
    {25, "C", :mu, :ch, :ko, "Invocatio Maior", [2, 4]},
    {26, "A", :mu, :ch, :ko, "Invocatio Minima", [2, 4]},
    {27, "B", :mu, :ch, :ko, "Invocatio Minor", [2, 4]},
    {28, "A", :kl, :in, :ko, "Katzenaugen", [4]},
    {29, "A", :kl, :in, :ko, "Krötensprung", [4]},
    {30, "A", :mu, :kl, :ch, "Manifesto", [1]},
    {31, "A", :kl, :ff, :kk, "Manus Miracula", [1]},
    {32, "B", :kl, :ff, :kk, "Motoricus", [1]},
    {33, "C", :mu, :kl, :ch, "Nebelwand", [3]},
    {34, "B", :kl, :in, :ch, "Oculus Illusionis", [2]},
    {35, "A", :kl, :in, :in, "Odem Arcanum", [1]},
    {36, "B", :kl, :in, :ko, "Paralysis", [2]},
    {37, "B", :mu, :kl, :in, "Penetrizzel", [2]},
    {38, "B", :kl, :in, :ff, "Psychostabilis", [1]},
    {39, "B", :kl, :ff, :kk, "Radau", [4]},
    {40, "B", :mu, :in, :ch, "Respondami", [2]},
    {41, "C", :kl, :in, :ko, "Salander", [2]},
    {42, "A", :mu, :in, :ch, "Sanftmut", [4]},
    {43, "B", :kl, :in, :ko, "Satuarias Herrlichkeit", [4]},
    {44, "B", :kl, :ff, :kk, "Silentium", [3]},
    {45, "B", :mu, :in, :ch, "Somnigravis", [3]},
    {46, "A", :kl, :in, :ko, "Spinnenlauf", [4]},
    {47, "B", :kl, :ff, :kk, "Spurlos", [3]},
    {48, "C", :mu, :ch, :ko, "Transversalis", [2]},
    {49, "B", :kl, :in, :ko, "Visibili", [3]},
    {50, "B", :kl, :in, :ko, "Wasseratem", [3]},
    {51, "D", :kl, :in, :ff, "Zauberklinge Geisterspeer", [1]}
  ]

  defp to_map({id, sf, t1, t2, t3, name, traditions}) do
    %{
      id: id,
      sf: sf,
      t1: t1,
      t2: t2,
      t3: t3,
      name: name,
      traditions: traditions
    }
  end

  def seed, do: Enum.each(@spells, &Data.create_spell(to_map(&1)))

  def reseed do
    spells = Data.list_spells()

    Enum.each(@spells, fn spell ->
      attrs = to_map(spell)

      case Enum.find(spells, &(&1.id == attrs.id)) do
        nil -> Data.create_spell!(attrs)
        spell -> Data.update_spell!(spell, attrs)
      end
    end)
  end
end
