defmodule Dsa.Data do
  use GenServer

  @name __MODULE__

  import Ecto.Query, warn: false

  alias Dsa.Repo
  alias Dsa.Data.Skill

  def start_link(_), do: GenServer.start_link(__MODULE__, [], name: @name)

  def init(_) do
    # Dsa.Data.Advantage.seed()
    # Dsa.Data.Armor.seed()
    # Dsa.Data.Blessing.seed()
    # Dsa.Data.Disadvantage.seed()
    # Dsa.Data.CombatSkill.seed()
    # Dsa.Data.CombatTrait.seed()
    # Dsa.Data.FateTrait.seed()
    # Dsa.Data.FWeapon.seed()
    # Dsa.Data.GeneralTrait.seed()
    # Dsa.Data.KarmalTradition.seed()
    # Dsa.Data.KarmalTrait.seed()
    # Dsa.Data.Language.seed()
    # Dsa.Data.MagicTradition.seed()
    # Dsa.Data.MagicTrait.seed()
    # Dsa.Data.MWeapon.seed()
    # Dsa.Data.Prayer.seed()
    # Dsa.Data.Script.seed()
    Skill.seed()
    # Dsa.Data.Species.seed()
    Dsa.Data.Spell.seed()
    # Dsa.Data.SpellTrick.seed()
    # Dsa.Data.StaffSpell.seed()

    {:ok, "In-Memory database created and filled."}
  end

  def list_skills do
    from(s in Skill, order_by: [s.category, s.name])
    |> Repo.all()
  end

  def get_skill(id), do: Repo.get(Skill, id)

  def create_skill!(attrs) do
    %Skill{}
    |> Skill.changeset(attrs)
    |> Repo.insert!()
  end

  def update_skill!(%Skill{} = skill, attrs) do
    skill
    |> Skill.changeset(attrs)
    |> Repo.update!()
  end
end
