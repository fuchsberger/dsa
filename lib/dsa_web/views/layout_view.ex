defmodule DsaWeb.LayoutView do
  use DsaWeb, :view

  import Phoenix.Controller, only: [get_flash: 1, get_flash: 2]

  alias Dsa.Accounts.User

  defp active_class(conn, path) do
    if path == Path.join(["/" | conn.path_info]), do: "active", else: nil
  end

  def link(conn, text, opts) do
    class = [opts[:class], active_class(conn, opts[:to])] |> Enum.filter(& &1) |> Enum.join(" ")
    link text, Keyword.put(opts, :class, class)
  end

  def link(:auth, conn, text, opts) do
    if auth?(conn), do: link(conn, text, opts), else: nil
  end

  def active_character_name(%User{active_character_id: character_id} = user) do
    case Enum.find(user.characters, fn {id, _name} -> id == character_id end) do
      nil -> nil
      {_id, name} -> name
    end
  end
end
