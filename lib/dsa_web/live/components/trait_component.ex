defmodule DsaWeb.TraitComponent do
  use DsaWeb, :live_component

  alias Dsa.Event

  @group_id 1

  def render(assigns) do
    ~L"""
    <div class='grid grid-cols-1 lg:grid-cols-5 gap-2 mb-3'>
      <h4 class='leading-8 text-center lg:text-left font-bold text-gray-700'>Eigenschaft</h4>
      <div class='col-span-2 grid grid-cols-4 gap-2'>
        <%= trait_button(@character, :mu, @myself) %>
        <%= trait_button(@character, :kl, @myself) %>
        <%= trait_button(@character, :in, @myself) %>
        <%= trait_button(@character, :ch, @myself) %>
      </div>
      <div class='col-span-2 grid grid-cols-4 gap-2'>
        <%= trait_button(@character, :ge, @myself) %>
        <%= trait_button(@character, :ff, @myself) %>
        <%= trait_button(@character, :ko, @myself) %>
        <%= trait_button(@character, :kk, @myself) %>
      </div>
    </div>
    """
  end

  def mount(socket), do: {:ok, socket}

  def handle_event("roll", %{"trait" => trait}, socket) do

    trait = trait |> String.downcase() |> String.to_atom()
    level = Map.get(socket.assigns.character, trait)

    d1 = Enum.random(1..20)
    d2 = Enum.random(1..20)

    params =
      %{
        type: 2,
        x1: Enum.find_index(~w(mu kl in ch ge ff ko kk)a, & &1 == trait), # trait
        x3: socket.assigns.modifier,
        x4: d1,
        x5: d2,
        x12: result(level, socket.assigns.modifier, d1, d2),
        character_id: socket.assigns.character.id,
        group_id: @group_id
      }

    case Event.create_log(params) do
      {:ok, log} ->
        broadcast({:log, Event.preload_character_name(log)})
        {:noreply, assign(socket, :log_open?, true)}

      {:error, changeset} ->
        Logger.error("Error occured while creating log entry: #{inspect(changeset)}")
        {:noreply, socket}
    end
  end

  def result(level, modifier, dice, dice_confirm) do
    cond do
      dice == 1 && dice_confirm <= level + modifier -> 2
      dice == 1 -> 1
      dice == 20 && dice_confirm > level + modifier -> -2
      dice == 20 -> -1
      dice <= level + modifier -> 1
      true -> -1
    end
  end

  defp trait_button(character, trait, target) do
    assigns = %{
      trait: trait |> Atom.to_string() |> String.upcase(),
      target: target,
      level: Map.get(character, trait)
    }
    ~L"""
    <button type='button' class="bg-white w-full h-8 leading-8 border border-gray-300 rounded-md shadow-sm text-sm leading-4 font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500" phx-click='roll' phx-target='<%= @target %>' phx-value-trait='<%= @trait %>'><%= @trait %> <%= @level %></button>
    """
  end
end
