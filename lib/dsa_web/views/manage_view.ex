defmodule DsaWeb.ManageView do
  use DsaWeb, :view

  import Dsa.Lists

  def entries(action, armors, skills, groups, users) do
    case action do
      :armors -> armors
      :skills -> skills
      :groups -> groups
      :users -> users
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

  def row(:armors, armor, admin?) do
    ~E"""
    <th scope='row'><%= armor.name %></th>
    <td class='text-center'><%= armor.rs %></td>
    <td class='text-center'><%= armor.be %></td>
    <td class='text-center'><%= if armor.penalties, do: "-1 GS, -1 INI", else: "-" %></td>
    <%= if admin?, do: submit_cell(armor.id) %>
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
    <%= if admin?, do: submit_cell(group.id) %>
    """
  end

  def row(:skills, skill, admin?) do
    ~E"""
    <td><%= skill.category %></td>
    <th scope='row'><%= skill.name %></th>
    <td class='text-center'><small><%= skill.e1 %>/<%= skill.e2 %>/<%= skill.e3 %></small></td>
    <td class='text-center'><%= skill.sf %></td>
    <td class='text-center'><%= be(skill.be) %></td>
    <%= if admin?, do: submit_cell(skill.id) %>
    """
  end

  def row(:users, user, admin?) do
    ~E"""
    <td><%= user.id %></td>
    <td><%= if user.admin, do: icon("star") %></td>
    <th scope='row'><%= user.name %></th>
    <td><%= user.username %></td>
    <td>***********</td>
    <%= if admin?, do: submit_cell(user.id) %>
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
    <%= action_cell() %>
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
    <%= action_cell() %>
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
    <%= action_cell() %>
    """
  end

  def form(:groups, form, users) do
    user_options = Enum.map(users, & {&1.name, &1.id})
    ~E"""
    <td>
      <%= text_input form, :name, class: "form-control-sm" %>
      <%= error_tag form, :name %>
    </td>
    <td>
      <%= select form, :master_id, user_options,
        class: "form-control-sm",
        prompt: "bitte wählen..."
      %>
      <%= error_tag form, :master_id %>
    </td>
    <td>
    </td>
    <%= action_cell() %>
    """
  end

  defp action_cell do
    ~E"""
    <td class='text-center'>
      <%= submit icon("ok", class: "text-primary"), class: "btn btn-sm btn-link" %>
      <button class='btn btn-sm btn-link' type='button' phx-click='cancel'>
        <i class='icon-cancel text-secondary'></i>
      </button>
    </td>
    """
  end

  defp submit_cell(id) do
    ~E"""
    <td class='text-center'>
      <button type='button' class='btn btn-sm py-0 btn-link' phx-click='edit' phx-value-id='<%= id %>'><i class='icon-edit text-primary'></i></button>
      <button type='button' class='btn btn-sm py-0 btn-link' phx-click='delete' phx-value-id='<%= id %>' data-confirm='Are you absolutely sure?'><i class='icon-cancel text-danger'></i></button>
    </td>
    """
  end
end
