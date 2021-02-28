defmodule DsaWeb.SkillComponent do
  use DsaWeb, :live_component

  alias Dsa.Data.Skill
  alias Dsa.{Accounts, Event, Repo}

  @group_id 1

  def render(assigns) do
    Phoenix.View.render DsaWeb.SkillView, "index.html", assigns
  end

  def mount(socket), do: {:ok, socket}

  def update(%{character: character, modifier: modifier}, socket) do
    {:ok, socket
    |> assign(:character, character)
    |> assign(:modifier, modifier)
    |> assign(:ap_1, ap(character, :skills, 1))
    |> assign(:ap_2, ap(character, :skills, 2))
    |> assign(:ap_3, ap(character, :skills, 3))
    |> assign(:ap_4, ap(character, :skills, 4))
    |> assign(:ap_5, ap(character, :skills, 5))}
  end


  def handle_event("roll", %{"skill" => id}, socket) do
    skill_id = String.to_integer(id)
    traits = Enum.map(Skill.traits(skill_id), & Map.get(socket.assigns.character, &1))
    level = Map.get(socket.assigns.character, Skill.field(skill_id))
    modifier = socket.assigns.modifier
    character_id = socket.assigns.character.id
    group_id = @group_id
    type = 4

    params = Dsa.Trial.handle_trial_event(traits, level, modifier, group_id, character_id, type, skill_id)

    case Event.create_log(params) do
      {:ok, log} ->
        broadcast({:log, Event.preload_character_name(log)})
        {:noreply, assign(socket, :log_open?, true)}

      {:error, changeset} ->
        Logger.error("Error occured while creating log entry: #{inspect(changeset)}")
        {:noreply, socket}
    end
  end

  defp row(target, skill_values, skill_id) do
    field = Skill.field(skill_id)
    value = Map.get(skill_values, field)

    assigns = %{
      id: skill_id,
      name: Skill.name(skill_id),
      probe: Skill.probe(skill_id),
      be: be(Skill.be(skill_id)),
      sf: Skill.sf(skill_id),
      value: value,
      show_minus: (if value == 0, do: "hidden"),
      show_plus: (if value == 29, do: "hidden"),
      target: target
    }
  end
end
