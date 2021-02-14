defmodule Dsa.Accounts do
  @moduledoc """
  The Accounts context.
  """
  import Ecto.{Changeset, Query}

  require Logger

  alias Dsa.Repo
  alias Dsa.Accounts.{Character, Group, User}

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
    Spell,
    SpellTrick,
    StaffSpell
  }

  alias Dsa.Event.Log

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
    spells: from(s in Spell, order_by: s.id),
    spell_tricks: from(s in SpellTrick, order_by: s.id),
    staff_spells: from(s in StaffSpell, order_by: s.id)
  ]

  @group_preloads [
    logs: from(l in Log, preload: :character, order_by: {:desc, l.inserted_at})
  ]

  def admin?(user_id), do: Repo.get(from(u in User, select: u.admin), user_id)

  def get_user!(id) do
    Repo.get!(from(u in User, preload: [:active_character]), id)
  end

  @spec get_user_base_data!(integer() | nil) :: tuple()

  def get_user_base_data!(nil), do: {nil, nil, nil, nil}

  def get_user_base_data!(id) do
    from(u in User, select: {u.id, u.username, u.email, u.active_character_id})
    |> Repo.get(id)
  end

  def get_user_characters(nil), do: []

  def get_user_characters(user_id) do
    from(c in Character,
      select: map(c, [:id, :name, :profession]),
      order_by: c.name,
      where: c.user_id == ^user_id
    ) |> Repo.all()
  end

  def get_user(id), do:  Repo.get(user_query(), id)

  def get_user_by(params), do: Repo.get_by(user_query(), params)

  defp user_query, do: from(u in User, preload: :characters)

  def authenticate_by_email_and_pass(email, given_pass) do
    user = get_user_by(email: email)

    cond do
      user && Pbkdf2.verify_pass(given_pass, user.password_hash) ->
        case user.confirmed do
          true -> {:ok, user}
          false -> {:error, :unconfirmed, user.email}
        end

      user ->
        {:error, :unauthorized}

      true ->
        Pbkdf2.no_user_verify()
        {:error, :not_found}
    end
  end

  def list_users, do: Repo.all(User)
  def list_user_options, do: Repo.all(from(u in User, select: {u.name, u.id}, order_by: u.name))

  def list_user_characters!(user_id) do
    from(c in Character,
      select: map(c, [:id, :name, :profession]),
      order_by: c.name,
      where: c.user_id == ^user_id
    )
    |> Repo.all()
  end

  def change_session(params \\ %{}), do: User.session_changeset(%User{}, params)

  def change_user(%User{} = user, params \\ %{}) do
    User.changeset(user, params)
  end

  def change_email(params), do: User.email_changeset(%User{}, params)

  def change_password(%User{} = user, params, bypass_security \\ false) do
    User.password_changeset(user, params, bypass_security)
  end

  def update_password(%User{} = user, params, bypass_security \\ false) do
    user
    |> User.password_changeset(params, bypass_security)
    |> Repo.update()
  end

  # Registration
  def change_registration(%User{} = user, params) do
    User.registration_changeset(user, params)
  end

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def reset_user(%User{} = user) do
    user
    |> change()
    |> User.put_token(true)
    |> Repo.update()
  end

  def update_user(%User{} = user, params \\ %{}) do
    user
    |> User.changeset(params)
    |> Repo.update()
  end

  def delete_user!(user), do: Repo.delete!(user)

  def list_characters, do: Repo.all(from(c in Character, preload: :user))

  def list_characters(list_of_ids) do
    from(c in Character, where: c.id in ^list_of_ids, select: {c.id, c})
    |> Repo.all()
    |> Map.new()
  end

  def get_character!(id), do: Repo.get!(Character, id)

  def get_character(id, :skills) do
    fields = [:id] ++ Skill.fields()
    Repo.get(from(c in Character, select: ^fields), id)
  end

  def preload(%Character{} = character) do
    Repo.preload(character, @character_preloads, force: true)
  end

  def change_character(%Character{} = character, attrs \\ %{}) do
    Character.changeset(character, attrs)
  end

  def change_character(%Character{} = character, attrs, :combat) do
    Character.combat_changeset(character, attrs)
  end

  def change_character(%Character{} = character, attrs, type) do
    Character.changeset(character, attrs, type)
  end

  def increment_character_skill(%Character{} = character, skill) do
    character
    |> Character.skill_changeset(Map.put(%{}, skill, Map.get(character, skill, 0) + 1))
    |> Repo.update()
  end

  def decrement_character_skill(%Character{} = character, skill) do
    character
    |> Character.skill_changeset(Map.put(%{}, skill, Map.get(character, skill, 0) - 1))
    |> Repo.update()
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

  def create_character(attrs) do
    %Character{}
    |> Character.changeset(attrs)
    |> Repo.insert()
  end

  def update_character(%Character{} = character, attrs) do
    character
    |> Character.changeset(attrs)
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

  def update_character(%Character{} = character, attrs, type) do
    character
    |> Character.changeset(attrs, type)
    |> Repo.update()
  end

  def update_character_assocs(%Character{} = character, attrs, type) do
    character
    |> change_character_assoc(attrs, type)
    |> Repo.update()
  end

  def delete_character(%Character{} = character), do: Repo.delete(character)

  def list_groups, do: Repo.all(from(g in Group, preload: :master))

  def list_group_options, do: Repo.all(from(g in Group, select: {g.name, g.id}, order_by: g.name))

  def create_group(attrs) do
    %Group{}
    |> Group.changeset(attrs)
    |> Repo.insert()
  end

  def change_group(%Group{} = group, attrs \\ %{}), do: Group.changeset(group, attrs)

  def get_group!(id), do: Repo.get!(from(g in Group, preload: ^@group_preloads), id)

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
  def add_spell(params), do: Spell.changeset(%Spell{}, params) |> Repo.insert()
  def add_spell_trick(params), do: SpellTrick.changeset(%SpellTrick{}, params) |> Repo.insert()
  def add_staff_spell(params), do: StaffSpell.changeset(%StaffSpell{}, params) |> Repo.insert()

  def delete(struct), do: Repo.delete(struct)
end
