defmodule Dsa.Characters do
  @moduledoc """
  The Characters context.
  Exposes and groups related character functionality.
  """
  import Ecto.Changeset, only: [cast_assoc: 3, put_assoc: 3]
  import Ecto.Query, warn: false

  alias Dsa.{Data, Repo}
  alias Dsa.Characters.{Character, CharacterSkill, CharacterSpell}
  alias Dsa.Accounts.User

  def list, do: Repo.all(Character)

  def list(%User{} = user) do
    from(c in Character, order_by: c.name, select: map(c, [:id, :name, :profession, :visible]))
    |> user_characters_query(user)
    |> Repo.all()
  end

  def fetch(id) do
    case Character |> preload_assocs() |> Repo.get(id) do
      nil -> {:error, :character_not_found}
      character -> {:ok, character}
    end
  end

  def get!(id) do
    Character
    |> preload_assocs()
    |> Repo.get!(id)
  end

  def get!(%User{} = user, id) do
    Character
    |> preload_assocs()
    |> user_characters_query(user)
    |> Repo.get!(id)
  end

  def create(%User{} = user, attrs) do
    %Character{}
    |> Character.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  def update(%Character{} = character, attrs) do
    character
    |> Character.changeset(attrs)
    |> cast_assoc(:character_skills, with: &CharacterSkill.changeset/2)
    |> cast_assoc(:character_spells, with: &CharacterSpell.changeset/2)
    |> Repo.update()
  end

  def change(%Character{} = character \\ %Character{}, attrs \\ %{}) do
    Character.changeset(character, attrs)
  end

  def delete(%Character{} = character), do: Repo.delete(character)

  def activate(%User{} = user, character) do
    user
    |> Repo.preload(:active_character)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:active_character, character)
    |> Repo.update()
  end

  def add_skills(%Character{} = character) do
    character_skill_ids = Enum.map(character.character_skills, & &1.skill_id)

    character_skills =
      Data.list_skills()
      |> Enum.reject(& Enum.member?(character_skill_ids, &1.id))
      |> Enum.map(& %CharacterSkill{
        character_id: character.id,
        skill_id: &1.id,
        level: 0
      })
      |> Enum.concat(character.character_skills)

    character
    |> Ecto.Changeset.change()
    |> put_assoc(:character_skills, character_skills)
    |> Repo.update()
  end

  def add_spells(%Character{} = character) do
    character_spell_ids = Enum.map(character.character_spells, & &1.spell_id)

    character_spells =
      Data.list_spells()
      |> Enum.reject(& Enum.member?(character_spell_ids, &1.id))
      |> Enum.map(& %CharacterSpell{
        character_id: character.id,
        spell_id: &1.id,
        level: 0
      })
      |> Enum.concat(character.character_spells)

    character
    |> Ecto.Changeset.change()
    |> put_assoc(:character_spells, character_spells)
    |> Repo.update()
  end

  def remove_skills(%Character{} = character) do
    character_skills = Enum.reject(character.character_skills, & &1.level == 0)

    character
    |> Ecto.Changeset.change()
    |> put_assoc(:character_skills, character_skills)
    |> Repo.update()
  end

  def remove_spells(%Character{} = character) do
    character_spells = Enum.reject(character.character_spells, & &1.level == 0)

    character
    |> Ecto.Changeset.change()
    |> put_assoc(:character_spells, character_spells)
    |> Repo.update()
  end

  defp preload_assocs(query) do
    character_skill_query = from(s in CharacterSkill, preload: :skill, order_by: s.skill_id)
    character_spell_query = from(s in CharacterSpell, preload: :spell, order_by: s.spell_id)
    from(c in query, preload: [character_skills: ^character_skill_query, character_spells: ^character_spell_query])
  end

  defp user_characters_query(query, %User{id: user_id}) do
    from(c in query, where: c.user_id == ^user_id)
  end

  # TODO: Recycle:

  # def add_advantage(params), do: Advantage.changeset(%Advantage{}, params) |> Repo.insert()
  # def add_armor(params), do: Armor.changeset(%Armor{}, params) |> Repo.insert()
  # def add_blessing(params), do: Blessing.changeset(%Blessing{}, params) |> Repo.insert()
  # def add_combat_trait(params), do: CombatTrait.changeset(%CombatTrait{}, params) |> Repo.insert()
  # def add_disadvantage(params), do: Disadvantage.changeset(%Disadvantage{}, params) |> Repo.insert()
  # def add_fate_trait(params), do: FateTrait.changeset(%FateTrait{}, params) |> Repo.insert()
  # def add_fweapon(params), do: FWeapon.changeset(%FWeapon{}, params) |> Repo.insert()
  # def add_general_trait(params), do: GeneralTrait.changeset(%GeneralTrait{}, params) |> Repo.insert()
  # def add_karmal_trait(params), do: KarmalTrait.changeset(%KarmalTrait{}, params) |> Repo.insert()
  # def add_language(params), do: Language.changeset(%Language{}, params) |> Repo.insert()
  # def add_magic_trait(params), do: MagicTrait.changeset(%MagicTrait{}, params) |> Repo.insert()
  # def add_mweapon(params), do: MWeapon.changeset(%MWeapon{}, params) |> Repo.insert()
  # def add_prayer(params), do: Prayer.changeset(%Prayer{}, params) |> Repo.insert()
  # def add_script(params), do: Script.changeset(%Script{}, params) |> Repo.insert()
  # def add_spell_trick(params), do: SpellTrick.changeset(%SpellTrick{}, params) |> Repo.insert()
  # def add_staff_spell(params), do: StaffSpell.changeset(%StaffSpell{}, params) |> Repo.insert()

  alias Dsa.Characters.CombatSet

  def list_combat_sets(%Character{} = character) do
    CombatSet
    |> character_combat_set_query(character)
    |> Repo.all()
  end

  def get_combat_set!(%Character{} = character, id) do
    CombatSet
    |> character_combat_set_query(character)
    |> Repo.get!(id)
  end

  defp character_combat_set_query(query, %Character{id: character_id}) do
    from(c in query, order_by: c.name, where: c.character_id == ^character_id)
  end

  def create_combat_set(character, attrs \\ %{}) do
    %CombatSet{}
    |> CombatSet.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:character, character)
    |> Repo.insert()
  end

  def update_combat_set(%CombatSet{} = combat_set, attrs) do
    combat_set
    |> CombatSet.changeset(attrs)
    |> Repo.update()
  end

  def delete_combat_set(%CombatSet{} = combat_set) do
    Repo.delete(combat_set)
  end

  def change_combat_set(%CombatSet{} = combat_set, attrs \\ %{}) do
    CombatSet.changeset(combat_set, attrs)
  end
end
