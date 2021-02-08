defmodule Dsa.Data do
  use GenServer

  @name __MODULE__

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
    Dsa.Data.Skill.seed()
    # Dsa.Data.Species.seed()
    # Dsa.Data.Spell.seed()
    # Dsa.Data.SpellTrick.seed()
    # Dsa.Data.StaffSpell.seed()

    {:ok, "In-Memory database created and filled."}
  end
end
