defmodule DsaWeb.LayoutView do
  use DsaWeb, :view

  import Phoenix.Controller, only: [current_path: 1, get_flash: 2]

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

  def menu_link(conn, name, target, opts \\ []) do
    {class, opts} = Keyword.pop(opts, :class)
    active_class = if current_path(conn) == target, do: " is-active", else: ""

    attrs =
      opts
      |> Keyword.put(:class, "navbar-item#{active_class} #{class}")
      |> Keyword.put(:to, target)

    link name, attrs
  end
end
