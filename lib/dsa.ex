defmodule Dsa do
  @moduledoc """
  Dsa keeps the contexts that define your domain and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.

  This can be used in your application as:

      use Dsa, :schema

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def schema do
    quote do
      use Ecto.Schema

      import Ecto.Changeset
      import Dsa, only: [slugify: 1, put_slug: 1, put_slug: 2]
      import DsaWeb.Gettext
    end
  end

  @doc """
  Converts a string into a url-friendly slug.
  """
  def slugify(string) when is_binary(string) do
    string
    |> String.downcase()
    |> String.replace(~r/[^a-z0-9\s-]/, "")
    |> String.replace(~r/(\s|-)+/, "-")
  end

  def put_slug(changeset, field \\ :name) do
    case changeset do
      %Ecto.Changeset{changes: %{name: name}} ->
        Ecto.Changeset.put_change(changeset, :slug, slugify(name))

      _ ->
        changeset
    end
  end

  def base_values, do: ~w(mu kl in ch ff ge ko kk)a

  @sf_values ~w(A B C D E)

  @talent_categories ~w(Körper Natur Gesellschaft Wissen Handwerk)

  # def base_value_options do
  #   Enum.map(@base_values, & {String.upcase(Atom.to_string(&1)), Atom.to_string(&1)})
  # end

  def combat_fields, do: Enum.map(1..21, & String.to_atom("c#{&1}"))

  def sf_values, do: @sf_values

  def talent_categories, do: @talent_categories

  @doc """
  When used, dispatch to the appropriate schema/context/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
