defmodule DsaWeb.ManageView do
  use DsaWeb, :view

  import Ecto.Changeset, only: [get_field: 2]
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

  def header(:armors, admin?) do
    ~E"""
    <th scope='col'>Name</th>
    <th scope='col' class='text-center'>RS</th>
    <th scope='col' class='text-center'>BE</th>
    <th scope='col' class='text-center'>Abzüge</th>
    <%= if admin?, do: content_tag :th, "Aktionen", scope: "col", class: "text-center" %>
    """
  end

  def header(:groups, admin?) do
    ~E"""
    <th scope='col'>Name</th>
    <th scope='col'>Meister</th>
    <th scope='col'></th>
    <%= if admin?, do: content_tag :th, "Aktionen", scope: "col", class: "text-center" %>
    """
  end

  def header(:skills, admin?) do
    ~E"""
    <th scope='col'>Talentgruppe</th>
    <th scope='col'>Name</th>
    <th scope='col' class='text-center'>Probe</th>
    <th scope='col' class='text-center'>SF</th>
    <th scope='col' class='text-center'>BE</th>
    <%= if admin?, do: content_tag :th, "Aktionen", scope: "col", class: "text-center" %>
    """
  end

  def header(:users, admin?) do
    ~E"""
    <th scope='col'>ID</th>
    <th scope='col'><i class='icon-star'></i></th>
    <th scope='col'>Name</th>
    <th scope='col'>Benutzername</th>
    <th scope='col'>Passwort</th>
    <%= if admin?, do: content_tag :th, "Aktionen", scope: "col", class: "text-center" %>
    """
  end

  def header(:weapons, admin?) do
    ~E"""
    <th scope='col'>Name</th>
    <th scope='col'>Kampftechnik</th>
    <th scope='col' class='text-center'>TP</th>
    <th scope='col' class='text-center'>RW</th>
    <th scope='col' class='text-center'>L+S / LZ</th>
    <th scope='col' class='text-center'>AT/PA</th>
    <%= if admin?, do: content_tag :th, "Aktionen", scope: "col", class: "text-center" %>
    """
  end

  def row(:armors, armor, admin?) do
    ~E"""
    <th scope='row'><%= armor.name %></th>
    <td class='text-center'><%= armor.rs %></td>
    <td class='text-center'><%= armor.be %></td>
    <td class='text-center'><%= if armor.penalties, do: "-1 GS, -1 INI", else: "-" %></td>
    """
  end

  def row(:groups, group, admin?) do
    ~E"""
    <th scope='row'><%= group.name %></th>
    <td><%= group.master.name %></td>
    <td>
      <button
        type='button'
        class='btn btn-sm py-0 btn-light text-primary'
        phx-click='remove-logs'
        phx-value-group='<%= group.id %>'
      >remove logs</button>
    </td>
    """
  end

  def row(:skills, skill, admin?) do
    ~E"""
    <td><%= skill.category %></td>
    <th scope='row'><%= skill.name %></th>
    <td class='text-center'><small><%= skill.e1 %>/<%= skill.e2 %>/<%= skill.e3 %></small></td>
    <td class='text-center'><%= skill.sf %></td>
    <td class='text-center'><%= be(skill.be) %></td>
    """
  end

  def row(:users, user, admin?) do
    ~E"""
    <td><%= user.id %></td>
    <td><%= if user.admin, do: icon("star") %></td>
    <th scope='row'><%= user.name %></th>
    <td><%= user.username %></td>
    <td>***********</td>
    """
  end

  def row(:weapons, weapon, admin?) do
    ~E"""
    <th scope='row'><%= weapon.name %></th>
    <td><%= weapon.combat_skill.name %></td>
    <td class='text-center'><%= "#{weapon.tp_dice}W+#{weapon.tp_bonus}" %></td>
    <td class='text-center'>
      <%=
        if weapon.combat_skill.ranged do
          "#{weapon.rw}/#{weapon.rw2}/#{weapon.rw3}"
        else
          case weapon.rw do
            1 -> "Kurz"
            2 -> "Mittel"
            3 -> "Lang"
          end
        end
      %>
    </td>
    <td class='text-center'>
      <%=
        if weapon.combat_skill.ranged do
          weapon.lz
        else
          "#{weapon.l1}#{if weapon.l2, do: "/#{weapon.l2}"} #{weapon.ls}"
        end
      %>
    </td>
    <td class='text-center'>
      <%= unless weapon.combat_skill.ranged, do: "#{weapon.at_mod}/#{weapon.pa_mod}" %>
    </td>
    """
  end

  def form(:armors, form) do
    ~E"""
    <td>
      <%= text_input form, :name, placeholder: "Name" %>
      <%= error_tag form, :name %>
    </td>
    <td>
      <%= number_input form, :rs, placeholder: "RS" %>
      <%= error_tag form, :rs %>
    </td>
    <td>
      <%= number_input form, :be, placeholder: "BE" %>
      <%= error_tag form, :be %>
    </td>
    <td>
      <%= checkbox form, :penalties %>
      <%= label form, :penalties, class: "form-check-label" %>
    </td>
    """
  end

  def form(:combat_skills, f) do
    ~E"""
    <td>
      <%= select f, :e1, base_value_options(), class: "form-select-sm" %>
    </td>
    <td>
      <%= select f, :e2, base_value_options(), class: "form-select-sm", prompt: "-" %>
    </td>
    <td><%= select f, :sf, sf_values(), class: "form-select-sm" %></td>
    """
  end

  def form(:skills, f) do
    ~E"""
    <td>
      <%= select f, :category, talent_categories(), class: "form-select-sm", prompt: "Gruppe" %>
      <%= error_tag f, :category %>
    </td>
    <td>
      <%= text_input f, :name, class: "form-control-sm", placeholder: "Name" %>
      <%= error_tag f, :name %>
    </td>
    <td>
      <div class='row g-0'>
        <div class='col'><%= select f, :e1, base_value_options(), class: "form-select-sm" %></div>
        <div class='col'><%= select f, :e2, base_value_options(), class: "form-select-sm" %></div>
        <div class='col'><%= select f, :e3, base_value_options(), class: "form-select-sm" %></div>
      </div>
    </td>
    <td><%= select f, :sf, sf_values(), class: "form-select-sm" %></td>
    <td>
    <%= select f, :be, [{"Ja", true}, {"Nein", false}], class: "form-select-sm", prompt: "Event." %>
    </td>
    """
  end

  def form(:users, form) do
    ~E"""
    <td></td>
    <td><%= checkbox form, :admin %></td>
    <td>
      <%= text_input form, :name, class: "form-control-sm" %>
      <%= error_tag form, :name %>
    </td>
    <td>
      <%= text_input form, :username, class: "form-control-sm" %>
      <%= error_tag form, :username %>
    </td>
    <td>
      <%= password_input form, :password, class: "form-control-sm" %>
      <%= error_tag form, :password %>
    </td>
    """
  end

  def form(:groups, form, users) do
    ~E"""
    <td>
      <%= text_input form, :name, class: "form-control-sm" %>
      <%= error_tag form, :name %>
    </td>
    <td>
      <%= select form, :master_id, Enum.map(users, & {&1.name, &1.id}),
        class: "form-control-sm",
        prompt: "bitte wählen..."
      %>
      <%= error_tag form, :master_id %>
    </td>
    <td>
    </td>
    """
  end

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

  defp action_cell(action, id) do
    ~E"""
    <td class='text-center'>
      <button
        type='button'
        class='btn btn-sm p-0 btn-link'
        phx-click='edit'
        phx-value-id='<%= id %>'
      ><i class='icon-edit text-primary'></i></button>
      <button
        type='button'
        class='btn btn-sm p-0 btn-link'
        phx-click='delete'
        phx-value-id='<%= id %>'
        data-confirm='Are you absolutely sure?'
      ><i class='icon-cancel text-danger'></i></button>
    </td>
    """
  end
end
