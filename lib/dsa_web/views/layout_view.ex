defmodule DsaWeb.LayoutView do
  use DsaWeb, :view

  import Phoenix.Controller, only: [get_flash: 1]
  import DsaWeb.AccountTranslations

  def title, do: gettext("DSA Tool")
  def description, do: gettext("Ein Heldenbogen-, Würfel- und Gruppentool für DSA, Das Schwarze Auge")

  # defp active_character_name(%User{} = current_user) do
  #   if is_nil(current_user.active_character_id) do
  #     gettext("No active character")
  #   else
  #     Enum.find(@current_user.characters, & &1.id == @current_user.active_character_id).name
  #   end
  # end

  def alert_colors(type) do
    case type do
      :error ->
        {"bg-red-50", "border-red-300", "text-red-400", "text-red-800", "x-circle-solid"}

      "info" ->
        {"bg-blue-50", "border-blue-300", "text-blue-400", "text-blue-800", "information-circle-solid"}

      "success" ->
        {"bg-green-50", "border-green-300", "text-green-400", "text-green-800", "check-circle-solid"}
    end
  end

  defp menu_item(conn, name, [to: path, icon: iname]) do
    active_class = if path == Path.join(["/" | conn.path_info]), do: " active"

    link [content_tag(:div, icon(conn, iname)), content_tag(:span, name)],
      to: path,
      class: "menu-item#{active_class}"
  end

  # size is in rem (by default 4 pixel)
  defp gravatar_url(email, size \\ 10) when is_binary(email) do
    email = email |> String.trim() |> String.downcase(:ascii)
    hash = :crypto.hash(:md5, email) |> Base.encode16(case: :lower)
    "https://www.gravatar.com/avatar/#{hash}?s=#{size*4}&d=mp"
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
