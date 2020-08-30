defmodule DsaWeb.LayoutView do
  use DsaWeb, :view

  def flash(conn, type) do
    case get_flash(conn, type) do
      nil -> nil
      msg ->
        color = if type == :error, do: "danger", else: Atom.to_string(type)

        ~E"""
          <div class='alert alert-<%= color %> alert-dismissible fade show' role='alert'>
            <%= msg %>
            <button type='button' class='close' data-dismiss='alert' aria-lable='close'>
              <span area-hidden='true'>&times;</span>
            </button>
          </div>
        """
    end
  end
end
