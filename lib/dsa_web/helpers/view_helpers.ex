defmodule DsaWeb.Helpers.ViewHelpers do
  @moduledoc """
  Conveniences for all views.
  """
  use Phoenix.HTML

  alias DsaWeb.Router.Helpers, as: Routes

  def action_submit(changeset) do
    action = if changeset.action == :insert, do: "create", else: "update"
    String.to_atom("#{action}_#{struct_name(changeset.data)}")
  end

  def auth?(conn), do: not is_nil(conn.assigns.current_user)

  def admin?(conn), do: conn.assigns.current_user && conn.assigns.current_user.admin

  def icon(name, class \\ "w-5 h-5") do
    content_tag :svg, class: class do
      tag(:use, href: Routes.static_path(DsaWeb.Endpoint, "/images/icons.svg#" <> name))
    end
  end

  def select_options(collection),
    do: [{"Please select...", nil} | Enum.map(collection, &{&1.name, &1.id})]

  def struct_to_string(s), do: Module.split(s.__struct__) |> List.last() |> String.downcase()

  def struct_to_atom(s), do: struct_to_string(s) |> String.to_atom()

  def struct_name(struct), do:
    struct.__struct__
    |> Module.split()
    |> List.last()
    |> String.downcase()

  def type(struct) do
    struct.__struct__
    |> to_string()
    |> String.split(".")
    |> List.last()
  end

  def check_to_string({t1, t2, t3}) when is_atom(t1) and is_atom(t2) and is_atom(t3) do
    "#{Atom.to_string(t1)}/#{Atom.to_string(t2)}/#{Atom.to_string(t3)}"
  end
end
