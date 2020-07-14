defmodule DsaWeb.ManageView do
  use DsaWeb, :view

  def new?(changeset), do: changeset && changeset.data.__meta__.state == :built
  def edit?(changeset), do: changeset && changeset.data.__meta__.state == :loaded

  def user_form_row(f) do
    ~E"""
      <tr>
        <td></td>
        <td></td>
        <td>
          <%= text_input f, :username, class: "form-control-sm" %>
          <%= error_tag f, :username %>
        </td>
        <td>
          <%= text_input f, :name, class: "form-control-sm" %>
          <%= error_tag f, :name %>
        </td>
        <td>
          <%= password_input f, :password, class: "form-control-sm" %>
          <%= error_tag f, :password %>
        </td>
        <td class='py-10 text-center'>
          <%= submit icon("add", class: "text-primary"), class: "btn btn-sm btn-light" %>
          <button class='btn btn-sm btn-light' type='button' phx-click='cancel'><i class='icon-cancel text-secondary'></i></button>
        </td>
      </tr>
    """
  end
end
