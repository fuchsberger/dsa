defmodule DsaWeb.LayoutView do
  use DsaWeb, :view

  import Phoenix.Controller, only: [get_flash: 1, get_flash: 2]
  import DsaWeb.AccountTranslations

  alias Dsa.Accounts.User

  defp active_character_name(%User{} = current_user) do
    if is_nil(current_user.active_character_id) do
      gettext("No active character")
    else
      Enum.find(@current_user.characters, & &1.id == @current_user.active_character_id).name
    end
  end

  def alert_colors(type) do
    case type do
      :error ->
        {"bg-red-50", "border-red-300", "text-red-400", "text-red-800", "x-circle-solid"}

      :info ->
        {"bg-blue-50", "border-blue-300", "text-blue-400", "text-blue-800", "information-circle-solid"}

      :success ->
        {"bg-green-50", "border-green-300", "text-green-400", "text-green-800", "check-circle-solid"}
    end
  end

  defp menu_items(conn, mobile) do
    [
      %{
        name: "Suche Synchronisieren",
        path: Routes.manage_path(conn, :sync_search),
        icon: "clipboard-list"
      }
    ]
    |> Enum.map(& Map.put(&1, :active, &1.path == Path.join(["/" | conn.path_info])))
    |> Enum.map(fn item ->
      link(conn, [icon(conn, item.icon, icon_class(mobile, item.active)), item.name],
        class: link_class(mobile, item.active), to: item.path)
    end)
  end

  # size is in rem (by default 4 pixel)
  defp gravatar_url(email, size \\ 10) when is_binary(email) do
    email = email |> String.trim() |> String.downcase(:ascii)
    hash = :crypto.hash(:md5, email) |> Base.encode16(case: :lower)
    "https://www.gravatar.com/avatar/#{hash}?s=#{size*4}&d=mp"
  end

  defp icon_class(mobile, active) when is_boolean(mobile) and is_boolean(active) do
    base = "h-6 w-6"
    default = "text-gray-400 group-hover:text-gray-300"
    current = "text-gray-300"

    case {mobile, active} do
      {false, false} -> "#{default} mr-4 #{base}"
      {false, true} -> "#{current} mr-4 #{base}"
      {true, false} -> "#{default} mr-3 #{base}"
      {true, true} -> "#{current} mr-3 #{base}"
    end
  end

  defp link_class(mobile, active) when is_boolean(mobile) and is_boolean(active) do
    base = "group flex items-center px-2 py-2 font-medium rounded-md"
    default = "text-gray-300 hover:bg-gray-700 hover:text-white"
    current = "bg-gray-900 text-white"

    case {mobile, active} do
      {false, false} -> "#{default} #{base} text-sm"
      {false, true} -> "#{current} #{base} text-sm"
      {true, false} -> "#{default} #{base} text-base"
      {true, true} -> "#{current} #{base} text-base"
    end
  end

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
end
