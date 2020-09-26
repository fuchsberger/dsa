defmodule DsaWeb.CharacterLive do
  use DsaWeb, :live_view

  import Dsa.Data

  alias Dsa.Accounts

  alias Dsa.Data.{
    Advantage,
    Armor,
    Blessing,
    CombatTrait,
    Disadvantage,
    FateTrait,
    FWeapon,
    GeneralTrait,
    KarmalTradition,
    KarmalTrait,
    Language,
    MagicTradition,
    MagicTrait,
    MWeapon,
    Prayer,
    Script,
    Spell,
    SpellTrick,
    StaffSpell
  }

  alias DsaWeb.Router.Helpers, as: Routes

  def render(assigns), do: DsaWeb.CharacterView.render("character.html", assigns)

  def mount(_params, %{"user_id" => user_id} = session, socket) do
    {:ok, assign_defaults(session, socket)
    |> assign(:edit, :disadvantages)
    |> assign(:category, 1)
    |> assign(:group_options, Accounts.list_group_options())
    |> assign(:magic_tradition_options, MagicTradition.options())
    |> assign(:karmal_tradition_options, KarmalTradition.options())
    |> assign(:user_id, user_id)
    |> assign(:admin?, Accounts.admin?(user_id))}
  end

  def handle_params(params, _session, socket) do
    case socket.assigns.live_action do
      :index ->
        {:noreply, assign(socket, :characters, Accounts.list_characters())}

      :edit ->
        case Accounts.get_character!(Map.get(params, "character_id")) do
          nil ->
            {:noreply, push_redirect(socket, to: Routes.manage_path(socket, :characters))}

          character ->
            {:noreply, socket
            |> assign(:character, character)
            |> assign(:changeset, Accounts.change_character(character))}
        end
    end
  end

  def handle_info({:updated_character, character}, socket) do
    {:noreply, assign(socket, :character, character)}
  end

  def handle_event("select", %{"category" => category}, socket) do
    {:noreply, assign(socket, :category, String.to_integer(category))}
  end

  def handle_event("change", %{"character" => %{"advantage_id" => id}}, socket) when id != "" do
    id = String.to_integer(id)
    c = socket.assigns.changeset.data
    case Accounts.add_advantage(%{
      advantage_id: id,
      character_id: c.id,
      level: Advantage.level(id),
      ap: Advantage.ap(id) * Advantage.level(id)
    }) do
      {:ok, %{advantage_id: id}} ->
        Logger.debug("#{c.name} has learned #{Advantage.name(id)} (advantage).")
        {:noreply, assign(socket, :changeset, Accounts.change_character(Accounts.preload(c)))}

      {:error, changeset} ->
        Logger.error("Error adding advantage: #{inspect(changeset.errors)}")
        {:noreply, socket}
    end
  end

  def handle_event("change", %{"character" => %{"add_armor_id" => id}}, socket) when id != "" do
    c = socket.assigns.changeset.data
    case Accounts.add_armor(%{armor_id: String.to_integer(id), character_id: c.id, dmg: 0}) do
      {:ok, %{id: id}} ->
        Logger.debug("#{c.name} has aquired #{Armor.name(id)} (armor).")
        {:noreply, assign(socket, :changeset, Accounts.change_character(Accounts.preload(c)))}

      {:error, changeset} ->
        Logger.error("Error adding armor: #{inspect(changeset.errors)}")
        {:noreply, socket}
    end
  end

  def handle_event("change", %{"character" => %{"blessing_id" => id}}, socket) when id != "" do
    c = socket.assigns.changeset.data
    case Accounts.add_blessing(%{id: id, character_id: c.id}) do
      {:ok, %{id: id}} ->
        Logger.debug("#{c.name} has learned #{Blessing.name(id)} (blessing).")
        {:noreply, assign(socket, :changeset, Accounts.change_character(Accounts.preload(c)))}

      {:error, changeset} ->
        Logger.error("Error adding blessing: #{inspect(changeset.errors)}")
        {:noreply, socket}
    end
  end

  def handle_event("change", %{"character" => %{"combat_trait_id" => id}}, socket) when id != "" do
    id = String.to_integer(id)
    c = socket.assigns.changeset.data
    case Accounts.add_combat_trait(%{id: id, character_id: c.id}) do
      {:ok, %{id: id}} ->
        Logger.debug("#{c.name} has learned #{CombatTrait.name(id)} (combat trait).")
        {:noreply, assign(socket, :changeset, Accounts.change_character(Accounts.preload(c)))}

      {:error, changeset} ->
        Logger.error("Error adding combat trait: #{inspect(changeset.errors)}")
        {:noreply, socket}
    end
  end

  def handle_event("change", %{"character" => %{"disadvantage_id" => id}}, socket) when id != "" do
    id = String.to_integer(id)
    c = socket.assigns.changeset.data
    case Accounts.add_disadvantage(%{
      disadvantage_id: id,
      character_id: c.id,
      level: Disadvantage.level(id),
      ap: Disadvantage.ap(id) * Disadvantage.level(id)
    }) do
      {:ok, %{disadvantage_id: id}} ->
        Logger.debug("#{c.name} has learned #{Disadvantage.name(id)} (disadvantage).")
        {:noreply, assign(socket, :changeset, Accounts.change_character(Accounts.preload(c)))}

      {:error, changeset} ->
        Logger.error("Error adding disadvantage: #{inspect(changeset.errors)}")
        {:noreply, socket}
    end
  end

  def handle_event("change", %{"character" => %{"fate_trait_id" => id}}, socket) when id != "" do
    id = String.to_integer(id)
    c = socket.assigns.changeset.data
    case Accounts.add_fate_trait(%{id: id, character_id: c.id}) do
      {:ok, %{id: id}} ->
        Logger.debug("#{c.name} has learned #{FateTrait.name(id)} (fate trait).")
        {:noreply, assign(socket, :changeset, Accounts.change_character(Accounts.preload(c)))}

      {:error, changeset} ->
        Logger.error("Error adding fate trait: #{inspect(changeset.errors)}")
        {:noreply, socket}
    end
  end

  def handle_event("change", %{"character" => %{"fweapon_id" => id}}, socket) when id != "" do
    c = socket.assigns.changeset.data
    case Accounts.add_fweapon(%{id: id, character_id: c.id, dmg: 0}) do
      {:ok, %{id: id}} ->
        Logger.debug("#{c.name} has aquired #{FWeapon.name(id)} (fweapon).")
        {:noreply, assign(socket, :changeset, Accounts.change_character(Accounts.preload(c)))}

      {:error, changeset} ->
        Logger.error("Error adding fweapon: #{inspect(changeset.errors)}")
        {:noreply, socket}
    end
  end

  def handle_event("change", %{"character" => %{"general_trait_id" => id}}, socket) when id != "" do
    id = String.to_integer(id)
    c = socket.assigns.changeset.data
    case Accounts.add_general_trait(%{id: id, character_id: c.id, ap: GeneralTrait.ap(id)}) do
      {:ok, %{id: id}} ->
        Logger.debug("#{c.name} has learned #{GeneralTrait.name(id)} (general trait).")
        {:noreply, assign(socket, :changeset, Accounts.change_character(Accounts.preload(c)))}

      {:error, changeset} ->
        Logger.error("Error adding general trait: #{inspect(changeset.errors)}")
        {:noreply, socket}
    end
  end

  def handle_event("change", %{"character" => %{"karmal_trait_id" => id}}, socket) when id != "" do
    id = String.to_integer(id)
    c = socket.assigns.changeset.data
    case Accounts.add_karmal_trait(%{karmal_trait_id: id, character_id: c.id, ap: KarmalTrait.ap(id)}) do
      {:ok, %{karmal_trait_id: id}} ->
        Logger.debug("#{c.name} has learned #{KarmalTrait.name(id)} (karmal trait).")
        {:noreply, assign(socket, :changeset, Accounts.change_character(Accounts.preload(c)))}

      {:error, changeset} ->
        Logger.error("Error adding karmal trait: #{inspect(changeset.errors)}")
        {:noreply, socket}
    end
  end

  def handle_event("change", %{"character" => %{"language_id" => id}}, socket) when id != "" do
    c = socket.assigns.changeset.data
    case Accounts.add_language(%{language_id: id, character_id: c.id}) do
      {:ok, %{language_id: id}} ->
        Logger.debug("#{c.name} has learned #{Language.name(id)} (language).")
        {:noreply, assign(socket, :changeset, Accounts.change_character(Accounts.preload(c)))}

      {:error, changeset} ->
        Logger.error("Error adding language: #{inspect(changeset.errors)}")
        {:noreply, socket}
    end
  end

  def handle_event("change", %{"character" => %{"magic_trait_id" => id}}, socket) when id != "" do
    id = String.to_integer(id)
    c = socket.assigns.changeset.data
    case Accounts.add_magic_trait(%{magic_trait_id: id, character_id: c.id, ap: MagicTrait.ap(id)}) do
      {:ok, %{magic_trait_id: id}} ->
        Logger.debug("#{c.name} has learned #{MagicTrait.name(id)} (magic trait).")
        {:noreply, assign(socket, :changeset, Accounts.change_character(Accounts.preload(c)))}

      {:error, changeset} ->
        Logger.error("Error adding magic trait: #{inspect(changeset.errors)}")
        {:noreply, socket}
    end
  end

  def handle_event("change", %{"character" => %{"mweapon_id" => id}}, socket) when id != "" do
    c = socket.assigns.changeset.data
    case Accounts.add_mweapon(%{id: id, character_id: c.id, dmg: 0}) do
      {:ok, %{id: id}} ->
        Logger.debug("#{c.name} has aquired #{MWeapon.name(id)} (meele weapon).")
        {:noreply, assign(socket, :changeset, Accounts.change_character(Accounts.preload(c)))}

      {:error, changeset} ->
        Logger.error("Error adding meele weapon: #{inspect(changeset.errors)}")
        {:noreply, socket}
    end
  end

  def handle_event("change", %{"character" => %{"prayer_id" => id}}, socket) when id != "" do
    c = socket.assigns.changeset.data
    case Accounts.add_prayer(%{id: id, character_id: c.id}) do
      {:ok, %{id: id}} ->
        Logger.debug("#{c.name} has learned #{Prayer.name(id)} (prayer).")
        {:noreply, assign(socket, :changeset, Accounts.change_character(Accounts.preload(c)))}

      {:error, changeset} ->
        Logger.error("Error adding prayer: #{inspect(changeset.errors)}")
        {:noreply, socket}
    end
  end

  def handle_event("change", %{"character" => %{"script_id" => id}}, socket) when id != "" do
    c = socket.assigns.changeset.data
    case Accounts.add_script(%{script_id: id, character_id: c.id}) do
      {:ok, %{script_id: id}} ->
        Logger.debug("#{c.name} has learned #{Script.name(id)} (script).")
        {:noreply, assign(socket, :changeset, Accounts.change_character(Accounts.preload(c)))}

      {:error, changeset} ->
        Logger.error("Error adding script: #{inspect(changeset.errors)}")
        {:noreply, socket}
    end
  end

  def handle_event("change", %{"character" => %{"spell_id" => id}}, socket) when id != "" do
    c = socket.assigns.changeset.data
    case Accounts.add_spell(%{id: id, character_id: c.id}) do
      {:ok, %{id: id}} ->
        Logger.debug("#{c.name} has learned #{Spell.name(id)} (spell).")
        {:noreply, assign(socket, :changeset, Accounts.change_character(Accounts.preload(c)))}

      {:error, changeset} ->
        Logger.error("Error adding spell: #{inspect(changeset.errors)}")
        {:noreply, socket}
    end
  end

  def handle_event("change", %{"character" => %{"spell_trick_id" => id}}, socket) when id != "" do
    c = socket.assigns.changeset.data
    case Accounts.add_spell_trick(%{id: id, character_id: c.id}) do
      {:ok, %{id: id}} ->
        Logger.debug("#{c.name} has learned #{StaffSpell.name(id)} (spell trick).")
        {:noreply, assign(socket, :changeset, Accounts.change_character(Accounts.preload(c)))}

      {:error, changeset} ->
        Logger.error("Error adding spell trick: #{inspect(changeset.errors)}")
        {:noreply, socket}
    end
  end

  def handle_event("change", %{"character" => %{"staff_spell_id" => id}}, socket) when id != "" do
    c = socket.assigns.changeset.data
    case Accounts.add_staff_spell(%{id: id, character_id: c.id}) do
      {:ok, %{id: id}} ->
        Logger.debug("#{c.name} has learned #{StaffSpell.name(id)} (staff spell).")
        {:noreply, assign(socket, :changeset, Accounts.change_character(Accounts.preload(c)))}

      {:error, changeset} ->
        Logger.error("Error adding staff spell: #{inspect(changeset.errors)}")
        {:noreply, socket}
    end
  end

  def handle_event("change", %{"character" => params}, socket) do
    case Accounts.update_character(socket.assigns.changeset.data, params) do
      {:ok, character} ->
        Logger.debug("Held verändert.")
        {:noreply, assign(socket, :changeset, Accounts.change_character(character))}

      {:error, changeset} ->
        Logger.error(inspect(changeset.errors))
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_event("delete", %{"id" => id}, socket) do
    character = Enum.find(socket.assigns.characters, & &1.id == String.to_integer(id))

    case Accounts.delete(character) do
      {:ok, character} ->
        Logger.debug("Held #{character.name} gelöscht.")
        characters = Enum.reject(socket.assigns.characters, & &1.id == character.id)
        {:noreply, assign(socket, :characters, characters)}

      {:error, reason} ->
        Logger.error(inspect(reason))
        {:noreply, socket}
    end
  end

  def handle_event("remove", %{"id" => id, "type" => type}, socket) do
    id = String.to_integer(id)
    character = socket.assigns.changeset.data

    {entry, name} =
      case type do
        "advantage" ->
          {Enum.find(character.advantages, & &1.advantage_id == id), Advantage.name(id)}

        "armor" ->
          {Enum.find(character.armors, & &1.id == id), Armor.name(id)}

        "blessing" ->
          {Enum.find(character.blessings, & &1.id == id), Blessing.name(id)}

        "combat_trait" ->
          {Enum.find(character.combat_traits, & &1.id == id), CombatTrait.name(id)}

        "disadvantage" ->
          {Enum.find(character.disadvantages, & &1.disadvantage_id == id), Disadvantage.name(id)}

        "fate_trait" ->
          {Enum.find(character.fate_traits, & &1.id == id), FateTrait.name(id)}

        "fweapon" ->
          {Enum.find(character.fweapons, & &1.id == id), FWeapon.name(id)}

        "general_trait" ->
          {Enum.find(character.general_traits, & &1.id == id), GeneralTrait.name(id)}

        "karmal_trait" ->
          {Enum.find(character.karmal_traits, & &1.karmal_trait_id == id), KarmalTrait.name(id)}

        "language" ->
          {Enum.find(character.languages, & &1.language_id == id), Language.name(id)}

        "magic_trait" ->
          {Enum.find(character.magic_traits, & &1.magic_trait_id == id), MagicTrait.name(id)}

        "mweapon" ->
          {Enum.find(character.mweapons, & &1.id == id), MWeapon.name(id)}

        "prayer" ->
          {Enum.find(character.prayers, & &1.id == id), Prayer.name(id)}

        "script" ->
          {Enum.find(character.scripts, & &1.script_id == id), Script.name(id)}

        "spell" ->
          {Enum.find(character.spells, & &1.id == id), Spell.name(id)}

        "spell_trick" ->
          {Enum.find(character.spell_tricks, & &1.id == id), SpellTrick.name(id)}

        "staff_spell" ->
          {Enum.find(character.staff_spells, & &1.id == id), StaffSpell.name(id)}
      end

    case Accounts.delete(entry) do
      {:ok, _entry} ->
        character = Accounts.preload(character)
        Logger.debug("#{character.name} lost #{name} (#{type}).")
        {:noreply, assign(socket, :changeset, Accounts.change_character(character))}

      {:error, reason} ->
        Logger.error("Error removing #{type}: #{inspect(reason)}")
        {:noreply, socket}
    end
  end

  def handle_event("toggle", %{"edit" => type}, socket) do
    edit = String.to_atom(type)
    {:noreply, assign(socket, :edit, (unless edit == socket.assigns.edit, do: edit, else: nil))}
  end
end
