defmodule DsaWeb.CharacterHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """
  use Phoenix.HTML
  import Ecto.Changeset, only: [get_field: 2]

  def ini(character) do
    basis = round((get_field(character, :MU) + get_field(character, :GE)) / 2)
    %{
      basis: basis,
      total: basis
    }
  end

  def ge(_character) do

  end
end
