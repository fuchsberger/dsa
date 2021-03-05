defmodule DsaWeb.LayoutView do
  use DsaWeb, :view

  import Phoenix.Controller, only: [get_flash: 2]

  alias Dsa.Accounts.User

  defp active_class(conn, path) do
    case path == Path.join(["/" | conn.path_info]) do
      true -> "active"
      false -> nil
    end
  end

  def active_character_name(%User{active_character_id: character_id} = user) do
    case Enum.find(user.characters, fn {id, _name} -> id == character_id end) do
      nil -> nil
      {_id, name} -> name
    end
  end

  def menu_link(conn, text, opts) do
    class =
      [opts[:class], active_class(conn, opts[:to])]
      |> Enum.filter(& &1)
      |> Enum.join(" ")

    link(text, Keyword.put(opts, :class, class))
  end

  def gravatar_url(user) do
    email = if is_nil(user), do: "unknown", else: user.email
    "https://s.gravatar.com/avatar/#{:erlang.md5(email) |> Base.encode16(case: :lower)}?s=32"
  end
end
