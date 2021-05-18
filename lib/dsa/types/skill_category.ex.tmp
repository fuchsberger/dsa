defmodule Dsa.Type.SkillCategory do
  use Ecto.Type

  import DsaWeb.Gettext

  @categories [
    %{
      id: :body,
      order: 0,
      title: gettext("Körpertalente"),
      short: gettext("Körper"),
      pages: "188-194",
      probe: "MU/GE/KK"
    }, %{
      id: :social,
      order: 1,
      title: gettext("Gesellschaftstalente"),
      short: gettext("Gesellschaft"),
      pages: "194-198",
      probe: "IN/CH/CH"
    }, %{
      id: :nature,
      order: 2,
      title: gettext("Naturtalente"),
      short: gettext("Natur"),
      pages: "198-201",
      probe: "MU/GE/KO"
    }, %{
      id: :knowledge,
      order: 3,
      title: gettext("Wissenstalente"),
      short: gettext("Wissen"),
      pages: "201-206",
      probe: "KL/KL/IN"
    }, %{
      id: :crafting,
      order: 4,
      title: gettext("Handwerkstalente"),
      short: gettext("Handwerk"),
      pages: "206-213",
      probe: "FF/FF/KO"
    }
  ]

  def type, do: :integer

  def list, do: @categories

  def list_types, do: Enum.map(@categories, & &1.id)

  def get(id, invalid_return \\ nil), do: Enum.find(@categories, invalid_return, & &1.id == id)

  def options, do: Enum.map(@categories, & {&1.short, &1.id})

  @doc """
  Converts a category atom into an index for efficient database storage
  """
  def cast(id) when is_binary(id), do: cast(String.to_atom(id))

  def cast(id) when is_atom(id) do
    with %{} = category <- get(id, :error), do: {:ok, category.order}
  end

  def cast(_), do: :error

  @doc """
  Converts a category index from database back into an atom (reverse of cast)
  """
  def load(index) do
    id =
      @categories
      |> Enum.find(& &1.order == index)
      |> Map.get(:id)

    {:ok, id}
  end

  # at this point input category was converted to index so just check datatyp
  def dump(category) when is_integer(category), do: {:ok, category}

  def count, do: Enum.count(@categories)
end
