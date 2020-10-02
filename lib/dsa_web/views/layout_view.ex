defmodule DsaWeb.LayoutView do
  use DsaWeb, :view

  import Phoenix.Controller, only: [current_path: 1, get_flash: 1]

  def menu_link(conn, name, target, opts \\ []) do
    {class, opts} = Keyword.pop(opts, :class)
    {character_id, opts} = Keyword.pop(opts, :character_id)

    path = current_path(conn)

    active_class =
      case character_id do
        nil -> if path == target, do: " is-active", else: ""
        id ->
          path = String.split(path, "/", trim: true)
          if Enum.at(path, 0) == "character" && Enum.at(path, 1) == Integer.to_string(id), do: " is-active", else: ""
      end

    attrs =
      opts
      |> Keyword.put(:class, "navbar-item#{active_class} #{class}")
      |> Keyword.put(:to, target)

    link name, attrs
  end
end
