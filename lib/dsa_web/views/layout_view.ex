defmodule DsaWeb.LayoutView do
  use DsaWeb, :view

  import Phoenix.Controller, only: [current_path: 1, get_flash: 1]

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
