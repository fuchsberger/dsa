defmodule DsaWeb.ViewHelpers do
  @moduledoc """
  Conveniences for all views.
  """
  use Phoenix.HTML

  alias Phoenix.HTML.Form
  alias DsaWeb.Router.Helpers, as: Routes

  def action_submit(changeset) do
    action = if changeset.action == :insert, do: "create", else: "update"
    String.to_atom("#{action}_#{struct_name(changeset.data)}")
  end

  def icon(socket, name, class \\ "inline-block w-6 h-6") do
    content_tag :svg, class: class do
      tag(:use, href: Routes.static_path(socket, "/images/icons.svg#" <> name))
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
end
