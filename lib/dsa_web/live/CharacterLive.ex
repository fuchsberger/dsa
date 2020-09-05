defmodule DsaWeb.CharacterLive do
  use Phoenix.LiveView
  require Logger

  alias Dsa.{Accounts, Lore}
  alias DsaWeb.Router.Helpers, as: Routes

  def render(assigns), do: DsaWeb.CharacterView.render("character.html", assigns)

  def mount(_params, %{"user_id" => user_id}, socket) do
    {:ok, socket
    |> assign(:category, 6)
    |> assign(:group_options, Accounts.list_group_options())
    |> assign(:spell_options, Lore.list_spell_options())
    |> assign(:wonder_options, Lore.list_wonder_options())
    |> assign(:user_id, user_id)}
  end

  def handle_params(params, _session, socket) do
    user_id = socket.assigns.user_id

    case socket.assigns.live_action do
      :index ->
        {:noreply, assign(socket, :characters, Accounts.list_user_characters(user_id))}

      :new ->


        {:noreply, assign(socket, :changeset, Accounts.change_character(%Accounts.Character{}))}

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
    category = if category == "0", do: nil, else: String.to_integer(category)
    {:noreply, assign(socket, :category, category)}
  end

  def handle_event("change", %{"character" => params}, socket) do
    character = socket.assigns.changeset.data
    # IO.inspect Map.get(params, "skill-id")
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

      true ->
        changeset = Accounts.change_character(character, params)
        {:noreply, assign(socket, :changeset, changeset)}
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
