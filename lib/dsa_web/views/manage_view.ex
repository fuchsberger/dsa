defmodule DsaWeb.ManageView do
  use DsaWeb, :view

  alias Dsa.Data.{
    CombatSkill,
    KarmalTradition,
    MagicTradition,
  }

  import Dsa.Lists

  def entries(action, armors, combat_skills, skills, groups, users, weapons) do
    case action do
      :armors -> armors
      :combat_skills -> combat_skills
      :skills -> skills
      :groups -> groups
      :users -> users
      :weapons -> weapons
    end
  end

  def new?(changeset), do: changeset && changeset.data.__meta__.state == :built
  def edit?(changeset), do: changeset && changeset.data.__meta__.state == :loaded

  def form(:weapons, f, combat_skills) do

    combat_skill =
      case input_value(f, :combat_skill_id) do
        "" -> nil
        nil -> nil
        id when is_binary(id) -> Enum.find(combat_skills, & &1.id == String.to_integer(id))
        id when is_integer(id) -> Enum.find(combat_skills, & &1.id == id)
      end

    ~E"""
    <td>
      <%= text_input f, :name, placeholder: "Name", class: "form-control-sm" %>
      <%= error_tag f, :name %>
    </td>
    <td>
      <%= select f, :combat_skill_id, Enum.map(combat_skills, & {&1.name, &1.id}), prompt: "Kampftechnik" %>
    </td>
    <td>
      <%= number_input f, :tp_dice, class: "form-control-sm", placeholder: "Würfel" %>
      <%= number_input f, :tp_bonus, class: "form-control-sm", placeholder: "Bonus" %>
      <%= error_tag f, :tp_dice %>
      <%= error_tag f, :tp_bonus %>
    </td>
    <td>
      <%= if combat_skill && combat_skill.ranged do %>
        <%= number_input f, :rw, placeholder: "Kurz", class: "form-control-sm" %>
        <%= number_input f, :rw2, placeholder: "Mittel", class: "form-control-sm" %>
        <%= number_input f, :rw3, placeholder: "Lang", class: "form-control-sm" %>
        <%= error_tag f, :rw %>
        <%= error_tag f, :rw2 %>
        <%= error_tag f, :rw3 %>
      <% else %>
        <%= select f, :rw, [{"Kurz", 1}, {"Mittel", 2}, {"Long", 3}] %>
      <% end %>
    </td>
    <td>
      <%= if combat_skill && combat_skill.ranged do %>
        <%= number_input f, :lz, placeholder: "Ladezeit", class: "form-control-sm" %>
        <%= error_tag f, :lz %>
      <% else %>
        <%= select f, :l1, base_value_options(), prompt: "LE" %>
        <%= select f, :l2, base_value_options(), prompt: "-" %>
        <%= number_input f, :ls, placeholder: "Schwelle", class: "form-control-sm" %>
        <%= error_tag f, :ls %>
      <% end %>
    </td>

    <td>
      <%= unless combat_skill && combat_skill.ranged do %>
        <%= number_input f, :at_mod, placeholder: "AT", class: "form-control-sm" %>
        <%= number_input f, :pa_mod, placeholder: "PA", class: "form-control-sm" %>
        <%= error_tag f, :at_mod %>
        <%= error_tag f, :pa_mod %>
      <% end %>
    </td>
    """
  end

  defp form_buttons do
    ~E"""
      <div class="btn-group">
        <button class='btn btn-sm btn-primary' type='submit'>
          <i class='icon-ok'></i>
        </button>
        <button class='btn btn-sm btn-secondary' type='button' phx-click='cancel'>
          <i class='icon-cancel'></i>
        </button>
      </div>
    """
  end

  defp action_cell(id) do
    ~E"""
    <td class='text-center py-0'>
      <button
        type='button'
        class='btn btn-sm p-0 btn-link'
        phx-click='edit'
        phx-value-id='<%= id %>'
      ><i class='icon-edit text-primary'></i></button>
      <button
        type='button'
        class='btn btn-sm p-0  btn-link'
        phx-click='delete'
        phx-value-id='<%= id %>'
        data-confirm='Are you absolutely sure?'
      ><i class='icon-cancel text-danger'></i></button>
    </td>
    """
  end

  def id_cell(admin) do
    ~E"""
    <th scope='col' class='text-center'>
      <%= if admin do %>
        <button type='button' class='btn btn-sm p-0 btn-link' phx-click='refresh'>
          <i class='icon-refresh text-primary'></i>
        </button>
      <% else %>
        ID
      <% end %>
    </th>
    """
  end

  def header_cell(action) do
    ~E"""
    <th scope='col' class='text-center'>
      <button type='button' class='btn btn-sm p-0 btn-link' phx-click='add'>
        <i class='icon-add text-primary'></i>
      </button>
      <%= if Enum.member?([:armors, :combat_skills], action) do %>
      <button type='button' class='btn btn-sm p-0 btn-link' phx-click='refresh'>
        <i class='icon-refresh text-primary'></i>
      </button>
      <% end %>
    </th>
    """
  end

  defp check_cell(form, field, value) do
    content_tag :td,
      checkbox(form, field, value: value, disabled: true, class: "form-check-input", id: nil),
      class: "text-center"
  end

  def form(changeset) do
    form_for changeset,  "#", [
      class: "#{unless is_nil(changeset.action), do: "was-validated"}",
      phx_change: :validate,
      phx_submit: :save,
      novalidate: true
    ]
  end
end
