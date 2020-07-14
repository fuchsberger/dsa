defmodule DsaWeb.ManageView do
  use DsaWeb, :view

  def new?(changeset), do: changeset && changeset.data.__meta__.state == :built
  def edit?(changeset), do: changeset && changeset.data.__meta__.state == :loaded

  def header(:groups) do
    ~E"""
    <th scope='col'>Name</th>
    <th scope='col'>Meister</th>
    <th scope='col' class='text-center'>Aktionen</th>
    """
  end

  def header(:skills) do
    ~E"""
    <th scope='col'>Name</th>
    <th scope='col'>Benutzername</th>
    <th scope='col'>Passwort</th>
    <th scope='col' class='text-center'>Aktionen</th>
    """
  end

  def header(:users) do
    ~E"""
    <th scope='col'>ID</th>
    <th scope='col'><i class='icon-star'></i></th>
    <th scope='col'>Name</th>
    <th scope='col'>Benutzername</th>
    <th scope='col'>Passwort</th>
    <th scope='col' class='text-center'>Aktionen</th>
    """
  end

  def row(:groups, group) do
    ~E"""
    <th scope='row'><%= group.name %></th>
    <td><%= group.master.name %></td>
    <%= submit_cell(group.id) %>
    """
  end

  def row(:users, user) do
    ~E"""
    <td><%= user.id %></td>
    <td><%= if user.admin, do: icon("star") %></td>
    <th scope='row'><%= user.name %></th>
    <td><%= user.username %></td>
    <td>***********</td>
    <%= submit_cell(user.id) %>
    """
  end

  def form(:groups, form) do
    ~E"""
    <td>
      <%= text_input form, :name, class: "form-control-sm" %>
      <%= error_tag form, :name %>
    </td>
    <td>
      <%= number_input form, :master_id, class: "form-control-sm" %>
      <%= error_tag form, :master_id %>
    </td>
    <%= action_cell() %>
    """
  end

  def form(:users, form) do
    ~E"""
    <td></td>
    <td></td>
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

  defp action_cell do
    ~E"""
    <td class='py-10 text-center'>
      <%= submit icon("ok", class: "text-primary"), class: "btn btn-sm btn-light" %>
      <button class='btn btn-sm btn-light' type='button' phx-click='cancel'>
        <i class='icon-cancel text-secondary'></i>
      </button>
    </td>
    """
  end

  defp submit_cell(id) do
    ~E"""
    <td class='py-10 text-center'>
      <button type='button' class='btn btn-sm btn-light' phx-click='edit' phx-value-id='<%= id %>'><i class='icon-edit text-primary'></i></button>
      <button type='button' class='btn btn-sm btn-light' phx-click='delete' phx-value-id='<%= id %>' data-confirm='Are you absolutely sure?'><i class='icon-delete text-danger'></i></button>
    </td>
    """
  end

  def tab(socket, action, title, active_action) do
    live_patch title,
      to: Routes.manage_path(socket, action),
      class: "nav-link#{if active_action == action, do: " active"}"
  end
end
