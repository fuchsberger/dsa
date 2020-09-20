defmodule Dsa.Accounts do
  @moduledoc """
  The Accounts context.
  """
  import Ecto.{Changeset, Query}

  require Logger

  alias Dsa.Repo
  alias Dsa.Accounts.{Character, CharacterArmor, CharacterFWeapon, CharacterMWeapon, Group, User, CharacterSpell, CharacterPrayer}

  alias Dsa.Data.{
    Advantage,
    Blessing,
    CombatTrait,
    Disadvantage,
    FateTrait,
    GeneralTrait,
    KarmalTrait,
    Language,
    MagicTrait,
    Script,
    SpellTrick,
    StaffSpell
  }

  @character_preloads [
    :group,
    :user,
    advantages: from(s in Advantage, order_by: s.advantage_id),
    blessings: from(s in Blessing, order_by: s.id),
    combat_traits: from(s in CombatTrait, order_by: s.id),
    disadvantages: from(s in Disadvantage, order_by: s.disadvantage_id),
    fate_traits: from(s in FateTrait, order_by: s.id),
    general_traits: from(s in GeneralTrait, order_by: s.id),
    karmal_traits: from(s in KarmalTrait, order_by: s.karmal_trait_id),
    languages: from(s in Language, order_by: s.language_id),
    magic_traits: from(s in MagicTrait, order_by: s.magic_trait_id),
    scripts: from(s in Script, order_by: s.script_id),
    spell_tricks: from(s in SpellTrick, order_by: s.id),
    staff_spells: from(s in StaffSpell, order_by: s.id),

    character_armors: from(s in CharacterArmor, order_by: s.armor_id),
    character_fweapons: from(s in CharacterFWeapon, order_by: s.fweapon_id),
    character_mweapons: from(s in CharacterMWeapon, order_by: s.mweapon_id),
    character_spells: from(s in CharacterSpell, order_by: s.spell_id),
    character_prayers: from(s in CharacterPrayer, order_by: s.prayer_id)
  ]

  def admin?(user_id), do: Repo.get(from(u in User, select: u.admin), user_id)

  def get_user(id), do:  Repo.get(user_query(), id)

  def get_user_by(params), do: Repo.get_by(user_query(), params)

  defp user_query() do
    from(u in User, preload: [characters: :group])
  end

  def authenticate_by_username_and_pass(username, given_pass) do
    user = get_user_by(username: username)

    cond do
      user && Pbkdf2.verify_pass(given_pass, user.password_hash) ->
        {:ok, user}

      user ->
        {:error, :unauthorized}

      true ->
        Pbkdf2.no_user_verify()
        {:error, :not_found}
    end
  end

  def list_users, do: Repo.all(User)
  def list_user_options, do: Repo.all(from(u in User, select: {u.name, u.id}, order_by: u.name))

  def list_user_characters(user_id) do
    from(c in Character, preload: ^@character_preloads, where: c.user_id == ^user_id)
    |> Repo.all()
  end

  def change_registration(%User{} = user, params \\ %{}) do
    User.registration_changeset(user, params)
  end

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def delete_user!(user), do: Repo.delete!(user)

  def list_characters() do
    Repo.all(from(c in Character, preload: [:user, :group]))
  end

  def get_user_character!(%User{} = user, id) do
    Character
    |> user_characters_query(user)
    |> Repo.get!(id)
  end

  def get_character!(id) do
    Repo.get!(from(c in Character, preload: ^@character_preloads), id)
  end

  def preload(%Character{} = character) do
    Repo.preload(character, @character_preloads, force: true)
  end

  defp user_characters_query(query, %User{id: user_id}) do
    from(v in query, preload: :group, where: v.user_id == ^user_id)
  end

  defp user_characters_query(query, user_id) do
    from(v in query, preload: :group, where: v.user_id == ^user_id)
  end

  def create_character(%User{} = user) do
    case (
      %Character{}
      |> Character.changeset(%{name: "Held", species_id: 1, user_id: user.id, group_id: 1})
      |> Repo.insert()
    ) do
      {:ok, %Character{id: id}} ->
        Logger.info("#{user.name} successfully created a character.")
        id

      {:error, changeset} ->
        Logger.error("Error adding character: #{inspect(changeset.errors)}")
        :error
    end
  end

  def update_character(%Character{} = character, attrs) do
    character
    |> Character.changeset(attrs)
    |> cast_assoc(:character_spells, with: &CharacterSpell.changeset/2)
    |> cast_assoc(:character_prayers, with: &CharacterPrayer.changeset/2)
    |> cast_assoc(:advantages, with: &Advantage.changeset/2)
    |> cast_assoc(:blessings, with: &Blessing.changeset/2)
    |> cast_assoc(:combat_traits, with: &CombatTrait.changeset/2)
    |> cast_assoc(:disadvantages, with: &Disadvantage.changeset/2)
    |> cast_assoc(:fate_traits, with: &FateTrait.changeset/2)
    |> cast_assoc(:general_traits, with: &GeneralTrait.changeset/2)
    |> cast_assoc(:karmal_traits, with: &KarmalTrait.changeset/2)
    |> cast_assoc(:languages, with: &Language.changeset/2)
    |> cast_assoc(:magic_traits, with: &MagicTrait.changeset/2)
    |> cast_assoc(:scripts, with: &Script.changeset/2)
    |> cast_assoc(:spell_tricks, with: &SpellTrick.changeset/2)
    |> cast_assoc(:staff_spells, with: &StaffSpell.changeset/2)
    |> Repo.update()
  end

  def update_character(%Character{} = character, attrs, :combat) do
    character
    |> Character.combat_changeset(attrs)
    |> Repo.update()
  end

  def delete_character!(character), do: Repo.delete!(character)

  def change_character(%Character{} = character, attrs \\ %{}) do
    Character.changeset(character, attrs)
  end

  def change_character(%Character{} = character, attrs, :combat) do
    Character.combat_changeset(character, attrs)
  end

  def list_groups, do: Repo.all(from(g in Group, preload: :master))

  def list_group_options, do: Repo.all(from(g in Group, select: {g.name, g.id}, order_by: g.name))

  def create_group(attrs) do
    %Group{}
    |> Group.changeset(attrs)
    |> Repo.insert()
  end

  def change_group(%Group{} = group, attrs \\ %{}), do: Group.changeset(group, attrs)

  def get_group!(id) do
    Repo.get!(from(g in Group, preload: [
      general_rolls: [:character],
      talent_rolls: [:character],
      trait_rolls: [:character],
      routine: [:character],
      characters: ^@character_preloads
    ]), id)
  end

  def add_character_spell(params) do
    %CharacterSpell{}
    |> CharacterSpell.changeset(params)
    |> Repo.insert()
  end

  def add_character_prayer(params) do
    %CharacterPrayer{}
    |> CharacterPrayer.changeset(params)
    |> Repo.insert()
  end

  def add_advantage(params), do: Advantage.changeset(%Advantage{}, params) |> Repo.insert()
  def add_blessing(params), do: Blessing.changeset(%Blessing{}, params) |> Repo.insert()
  def add_combat_trait(params), do: CombatTrait.changeset(%CombatTrait{}, params) |> Repo.insert()
  def add_disadvantage(params), do: Disadvantage.changeset(%Disadvantage{}, params) |> Repo.insert()
  def add_fate_trait(params), do: FateTrait.changeset(%FateTrait{}, params) |> Repo.insert()
  def add_general_trait(params), do: GeneralTrait.changeset(%GeneralTrait{}, params) |> Repo.insert()
  def add_karmal_trait(params), do: KarmalTrait.changeset(%KarmalTrait{}, params) |> Repo.insert()
  def add_language(params), do: Language.changeset(%Language{}, params) |> Repo.insert()
  def add_magic_trait(params), do: MagicTrait.changeset(%MagicTrait{}, params) |> Repo.insert()
  def add_script(params), do: Script.changeset(%Script{}, params) |> Repo.insert()
  def add_spell_trick(params), do: SpellTrick.changeset(%SpellTrick{}, params) |> Repo.insert()
  def add_staff_spell(params), do: StaffSpell.changeset(%StaffSpell{}, params) |> Repo.insert()
  def remove(struct), do: Repo.delete(struct)
end
