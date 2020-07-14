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

  def nav_dropdown(title, do: block) do
    id= "drop_#{slugify(title)}"

    ~E"""
      <li class='nav-item dropdown'>
        <a href='#' id='<%= id %>' class='nav-link dropdown-toggle' role='button' data-toggle='dropdown' area-expanded='false'><%= title %></a>
        <ul class="dropdown-menu" aria-labelledby="<%= id %>"><%= block %></ul>
      </li>
    """
  end

  defp slugify(str) do
    str
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/u, "-")
  end
end
