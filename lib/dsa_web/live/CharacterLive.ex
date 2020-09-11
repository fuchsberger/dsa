defmodule DsaWeb.CharacterLive do
  use Phoenix.LiveView
  require Logger

  import Ecto.Changeset, only: [get_change: 2, get_field: 2]
  alias Dsa.{Accounts, Lore, Repo}
  alias DsaWeb.Router.Helpers, as: Routes

  def render(assigns), do: DsaWeb.CharacterView.render("character.html", assigns)

  def mount(_params, %{"user_id" => user_id}, socket) do
    {:ok, socket
    |> assign(:show_trait_form?, false)
    |> assign(:category, 1)
    |> assign(:traits, Lore.list_traits())
    |> assign(:species_options, Lore.options(:species))
    |> assign(:group_options, Accounts.list_group_options())
    |> assign(:spell_options, Lore.options(:spells))
    |> assign(:wonder_options, Lore.options(:wonders))
    |> assign(:magic_traditions_options, Lore.options(:magic_traditions))
    |> assign(:karmal_traditions_options, Lore.options(:karmal_traditions))
    |> assign(:user_id, user_id)}
  end

  def handle_params(params, _session, socket) do
    user_id = socket.assigns.user_id

    case socket.assigns.live_action do
      :index ->
        {:noreply, assign(socket, :characters, Accounts.list_user_characters(user_id))}

      :edit ->
        case Accounts.get_user_character!(user_id, Map.get(params, "character_id")) do
          nil ->
            {:noreply, push_redirect(socket, to: Routes.character_path(socket, :index))}

          character ->
            {:noreply, assign(socket, :changeset, Accounts.change_character(character))}
        end
    end
  end

  def handle_event("select", %{"category" => category}, socket) do
    {:noreply, assign(socket, :category, String.to_integer(category))}
  end

  def handle_event("toggle-trait-form", _params, socket) do
    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_change(:trait_id, nil)
      |> Ecto.Changeset.put_change(:trait_details, nil)
      |> Ecto.Changeset.put_change(:trait_level, nil)
      |> Ecto.Changeset.put_change(:trait_ap, nil)

    {:noreply, socket
    |> assign(:show_trait_form?, !socket.assigns.show_trait_form?)
    |> assign(:changeset, changeset)}
  end

  def handle_event("change", %{"character" => params}, socket) do
    character = socket.assigns.changeset.data

    trait_id =
      if Map.get(params, "trait_id") == "",
        do: nil,
        else: String.to_integer(Map.get(params, "trait_id"))

    cond do
      not is_nil(Map.get(params, "skill_id")) ->
        skill_id = params |> Map.get("skill_id") |> String.to_integer()
        case Accounts.add_character_skill(character.id, skill_id) do
          {:ok, _character_skill} ->
            Logger.debug("Added Skill...")
            changeset =
              character
              |> Accounts.preload()
              |> Accounts.change_character(Map.delete(params, "skill_id"))
            {:noreply, assign(socket, :changeset, changeset)}

          {:error, changeset} ->
            Logger.error(inspect(changeset.errors))
            {:noreply, socket}
        end

      # a new trait is being selected_for adding
      not is_nil(trait_id) ->
        trait = Enum.find(socket.assigns.traits, & &1.id == trait_id)

        trait_details = if trait.details, do: params |> Map.get("trait_details"), else: ""

        trait_level =
          params
          |> Map.get("trait_level", Integer.to_string(min(1, trait.level)))
          |> String.to_integer()

        trait_ap = case trait.fixed_ap do
          true -> if trait_level > 1, do: trait.ap * trait_level, else: trait.ap
          false -> Map.get(params, "trait_ap")
        end

        changeset =
          socket.assigns.changeset
          |> Ecto.Changeset.put_change(:trait_id, trait_id)
          |> Ecto.Changeset.put_change(:trait_details, trait_details)
          |> Ecto.Changeset.put_change(:trait_level, trait_level)
          |> Ecto.Changeset.put_change(:trait_ap, trait_ap)

        {:noreply, assign(socket, :changeset, changeset)}

      # normal character change
      true ->
        case Accounts.update_character(character, params) do
          {:ok, character} ->
            character = Repo.preload(character, :species, force: true)
            Logger.debug("Held verändert.")
            {:noreply, assign(socket, :changeset, Accounts.change_character(character))}

          {:error, changeset} ->
            Logger.error(inspect(changeset.errors))
            {:noreply, assign(socket, :changeset, changeset)}
        end
    end
  end

  def handle_event("add-trait", _params, socket) do
    params = %{
      character_id: get_field(socket.assigns.changeset, :id),
      trait_id: get_change(socket.assigns.changeset, :trait_id),
      level: get_change(socket.assigns.changeset, :trait_level),
      ap: get_change(socket.assigns.changeset, :trait_ap),
      details: get_change(socket.assigns.changeset, :trait_details),
    }

    case Accounts.add_character_trait(params) do
      {:ok, _character_trait} ->
        Logger.debug("Character trait added.")
        character = Accounts.preload(socket.assigns.changeset.data)
        {:noreply, assign(socket, :changeset, Accounts.change_character(character))}

      {:error, changeset} ->
        Logger.error("Error adding character trait: #{inspect(changeset.errors)}")
        {:noreply, socket}
    end
  end

  def handle_event("delete", %{"id" => character_id}, socket) do
    character = Accounts.get_user_character!(socket.assigns.user_id, String.to_integer(character_id))

    case Repo.delete(character) do
      {:ok, character} ->
        Logger.debug("Held gelöscht.")
        characters = Enum.reject(socket.assigns.characters, & &1.id == character.id)
        {:noreply, assign(socket, :characters, characters)}

      {:error, reason} ->
        Logger.error(inspect(reason))
        {:noreply, socket}
    end
  end

  def handle_event("delete", %{"trait" => id}, socket) do
    character = socket.assigns.changeset.data
    character_trait = Enum.find(character.character_traits, & &1.id == String.to_integer(id))

    case Accounts.remove_character_trait(character_trait) do
      {:ok, _character_skill} ->
        character = Accounts.preload(character)
        Logger.debug("Removed trait from #{character.name}.")
        {:noreply, assign(socket, :changeset, Accounts.change_character(character))}

      {:error, reason} ->
        Logger.error("Error removing trait: #{inspect(reason)}")
        {:noreply, socket}
    end
  end

  def handle_event("delete", %{"skill" => skill_id}, socket) do
    character = socket.assigns.changeset.data

    case Accounts.remove_character_skill(character.id, String.to_integer(skill_id)) do
      {:ok, _character_skill} ->
        Logger.debug("Held hat Zauber / Liturgie vergessen.")
        changeset =
          character
          |> Accounts.preload()
          |> Accounts.change_character(socket.assigns.changeset.changes)
        {:noreply, assign(socket, :changeset, changeset)}

      {:error, reason} ->
        Logger.error(inspect(reason))
        {:noreply, socket}
    end
  end
end
