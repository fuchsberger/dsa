defmodule Dsa.Accounts do
  @moduledoc """
  The Accounts context.
  """
  import Ecto.{Changeset, Query}

  require Logger

  alias Dsa.{Data, Repo}
  alias Dsa.Accounts.{Character, CharacterSkill, Group, User}

  alias Dsa.Data.{
    Advantage,
    Armor,
    Blessing,
    CombatTrait,
    Disadvantage,
    FateTrait,
    FWeapon,
    GeneralTrait,
    KarmalTrait,
    Language,
    MagicTrait,
    MWeapon,
    Prayer,
    Script,
    Skill,
    # Spell,
    SpellTrick,
    StaffSpell
  }

  alias Dsa.Event.{Log, SkillRoll}

  @character_preloads [
    :user,
    advantages: from(a in Advantage, order_by: a.id),
    armors: from(s in Armor, order_by: s.id),
    blessings: from(s in Blessing, order_by: s.id),
    combat_traits: from(s in CombatTrait, order_by: s.id),
    disadvantages: from(s in Disadvantage, order_by: s.disadvantage_id),
    fate_traits: from(s in FateTrait, order_by: s.fate_trait_id),
    fweapons: from(s in FWeapon, order_by: s.id),
    general_traits: from(s in GeneralTrait, order_by: s.id),
    karmal_traits: from(s in KarmalTrait, order_by: s.karmal_trait_id),
    languages: from(s in Language, order_by: s.language_id),
    magic_traits: from(s in MagicTrait, order_by: s.magic_trait_id),
    mweapons: from(s in MWeapon, order_by: s.id),
    prayers: from(s in Prayer, order_by: s.id),
    scripts: from(s in Script, order_by: s.script_id),
    spell_tricks: from(s in SpellTrick, order_by: s.id),
    staff_spells: from(s in StaffSpell, order_by: s.id)
  ]

  @group_preloads [
    logs: from(l in Log, preload: :character, order_by: {:desc, l.inserted_at})
  ]

  ##########################################################
  # User related APIs

  def list_users, do: Repo.all(User)

  def admin?(user_id), do: Repo.get(from(u in User, select: u.admin), user_id)

  def get_user!(id), do: Repo.get!(User, id)

  @spec get_user_base_data!(integer() | nil) :: tuple()

  def get_user_base_data!(nil), do: {nil, nil, nil, nil}

  def get_user_base_data!(id) do
    from(u in User, select: {u.id, u.username, u.email, u.active_character_id})
    |> Repo.get(id)
  end

  @doc """
  Always assigned to conn, and thus available through entire app if user is logged in.
  Also preloads character names and ids for menu.
  """
  def get_user(id) do
    character_query = from(c in Character, select: {c.id, c.name})
    Repo.get(from(u in User, preload: [ characters: ^character_query]), id)
  end

  def get_user_by(params), do: Repo.get_by(user_query(), params)

  defp user_query, do: from(u in User, preload: [:active_character, :characters])

  def authenticate_by_email_and_password(email, given_pass) do
    user = get_user_by(email: email)

    cond do
      user && Pbkdf2.verify_pass(given_pass, user.password_hash) ->
        case user.confirmed do
          true -> {:ok, user}
          false -> {:error, :unconfirmed}
        end

      user ->
        {:error, :invalid_credentials}

      true ->
        Pbkdf2.no_user_verify()
        {:error, :invalid_credentials}
    end
  end

  def leave_group(%User{} = user) do
    user
    |> User.changeset(%{group_id: nil})
    |> Repo.update()
  end

  def preload_characters(%User{} = user) do
    Repo.preload(user, characters: from(c in Character, order_by: c.name))
  end

  ##########################################################
  # Character related APIs

  @doc """
  Lists a user's characters (limited info, for dashboard only)
  """
  def list_user_characters(%User{} = user) do
    from(c in Character, order_by: c.name, select: map(c, [:id, :name, :profession, :visible]))
    |> user_characters_query(user)
    |> Repo.all()
  end

  @doc """
  Gets any character; used for character overview page (public).
  TODO: May want to preload more info
  """
  def get_character!(id), do: Repo.get!(Character, id)

  def get_user_character!(%User{} = user, id) do
    Character
    |> user_characters_query(user)
    |> Repo.get!(id)
  end

  def get_user_group!(%User{} = user) do
    user
    |> Repo.preload(:group)
    |> Map.get(:group)
  end

  defp user_characters_query(query, %User{id: user_id}) do
    character_skill_query = from(s in CharacterSkill, preload: :skill, order_by: s.skill_id)

    from(c in query,
      preload: [character_skills: ^character_skill_query],
      where: c.user_id == ^user_id)
  end

  def change_user(%User{} = user, params \\ %{}), do: User.changeset(user, params)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def change_registration(%User{} = user, params) do
    User.registration_changeset(user, params)
  end

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def manage_user!(%User{} = user, params) do
    user
    |> User.manage_changeset(params)
    |> Repo.update!()
  end

  def change_email(params), do: User.email_changeset(%User{}, params)

  def change_password(%User{} = user, params) do
    User.password_changeset(user, params)
  end

  def update_password(%User{} = user, params) do
    user
    |> User.password_changeset(params)
    |> Repo.update()
  end

  def reset_user(%User{} = user) do
    user
    |> change()
    |> User.put_token()
    |> Repo.update()
  end

  def update_user(%User{} = user, params \\ %{}) do
    user
    |> User.changeset(params)
    |> Repo.update()
  end

  def delete_user(%User{} = user), do: Repo.delete(user)

  def get_visible_characters do
    from(c in Character, where: c.visible == true, order_by: [desc: c.ini, asc: c.name])
    |> Repo.all()
  end

  def preload(%Character{} = character) do
    Repo.preload(character, @character_preloads, force: true)
  end

  def change_character(%Character{} = character, attrs \\ %{}) do
    Character.changeset(character, attrs)
  end

  def change_character_assoc(%Character{} = character, nil, type) do
    character
    |> cast(%{}, [])
    |> put_assoc(type, [])
  end

  def change_character_assoc(%Character{} = character, attrs, type) do
    character
    |> cast(attrs, [])
    |> cast_assoc(type)
  end

  def activate_character(user, character) do
    user
    |> Repo.preload(:active_character)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:active_character, character)
    |> Repo.update()
  end

  def create_character(%User{} = user, attrs) do
    %Character{}
    |> Character.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  def update_character(%Character{} = character, attrs) do
    character
    |> Character.changeset(attrs)
    |> cast_assoc(:character_skills, with: &CharacterSkill.changeset/2)
    # |> cast_assoc(:armors, with: &Armor.changeset/2)
    # |> cast_assoc(:blessings, with: &Blessing.changeset/2)
    # |> cast_assoc(:combat_traits, with: &CombatTrait.changeset/2)
    # |> cast_assoc(:disadvantages, with: &Disadvantage.changeset/2)
    # |> cast_assoc(:fate_traits, with: &FateTrait.changeset/2)
    # |> cast_assoc(:fweapons, with: &FWeapon.changeset/2)
    # |> cast_assoc(:general_traits, with: &GeneralTrait.changeset/2)
    # |> cast_assoc(:karmal_traits, with: &KarmalTrait.changeset/2)
    # |> cast_assoc(:languages, with: &Language.changeset/2)
    # |> cast_assoc(:magic_traits, with: &MagicTrait.changeset/2)
    # |> cast_assoc(:mweapons, with: &MWeapon.changeset/2)
    # |> cast_assoc(:prayers, with: &Prayer.changeset/2)
    # |> cast_assoc(:scripts, with: &Script.changeset/2)
    # |> cast_assoc(:spells, with: &Spell.changeset/2)
    # |> cast_assoc(:spell_tricks, with: &SpellTrick.changeset/2)
    # |> cast_assoc(:staff_spells, with: &StaffSpell.changeset/2)
    |> Repo.update()
  end

  def update_character!(%Character{} = character, attrs) do
    character
    |> Character.changeset(attrs)
    |> Repo.update!()
  end

  def delete_character(%Character{} = character), do: Repo.delete(character)

  ##########################################################
  # Group related APIs

  def list_groups, do: Repo.all(from(g in Group, preload: :master))

  def list_group_options, do: Repo.all(from(g in Group, select: {g.name, g.id}, order_by: g.name))

  def create_group(attrs) do
    %Group{}
    |> Group.changeset(attrs)
    |> Repo.insert()
  end

  def change_group(%Group{} = group, attrs \\ %{}), do: Group.changeset(group, attrs)

  def add_skills(character) do
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

  def remove_skills(character) do
    character_skills = Enum.reject(character.character_skills, & &1.level == 0)

    character
    |> Ecto.Changeset.change()
    |> put_assoc(:character_skills, character_skills)
    |> Repo.update()
  end

  def add_advantage(params), do: Advantage.changeset(%Advantage{}, params) |> Repo.insert()
  def add_armor(params), do: Armor.changeset(%Armor{}, params) |> Repo.insert()
  def add_blessing(params), do: Blessing.changeset(%Blessing{}, params) |> Repo.insert()
  def add_combat_trait(params), do: CombatTrait.changeset(%CombatTrait{}, params) |> Repo.insert()
  def add_disadvantage(params), do: Disadvantage.changeset(%Disadvantage{}, params) |> Repo.insert()
  def add_fate_trait(params), do: FateTrait.changeset(%FateTrait{}, params) |> Repo.insert()
  def add_fweapon(params), do: FWeapon.changeset(%FWeapon{}, params) |> Repo.insert()
  def add_general_trait(params), do: GeneralTrait.changeset(%GeneralTrait{}, params) |> Repo.insert()
  def add_karmal_trait(params), do: KarmalTrait.changeset(%KarmalTrait{}, params) |> Repo.insert()
  def add_language(params), do: Language.changeset(%Language{}, params) |> Repo.insert()
  def add_magic_trait(params), do: MagicTrait.changeset(%MagicTrait{}, params) |> Repo.insert()
  def add_mweapon(params), do: MWeapon.changeset(%MWeapon{}, params) |> Repo.insert()
  def add_prayer(params), do: Prayer.changeset(%Prayer{}, params) |> Repo.insert()
  def add_script(params), do: Script.changeset(%Script{}, params) |> Repo.insert()
  def add_spell_trick(params), do: SpellTrick.changeset(%SpellTrick{}, params) |> Repo.insert()
  def add_staff_spell(params), do: StaffSpell.changeset(%StaffSpell{}, params) |> Repo.insert()

  def delete(struct), do: Repo.delete(struct)
end
