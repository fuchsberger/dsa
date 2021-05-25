defmodule Dsa.Data.Skill do
  use Ecto.Schema

  import Ecto.Changeset
  import DsaWeb.Gettext

  alias Dsa.Type.{Check, CostFactor, SkillCategory}

  @traits ~w(MU KL IN CH FF GE KO KK)

  schema "skills" do
    field :applications, {:array, :string}
    field :name, :string
    field :description, :string
    field :encumbrance_default, :boolean, default: false
    field :encumbrance_conditional, :string
    field :category, SkillCategory
    field :check, Check
    field :cost_factor, CostFactor
    field :quality, :string
    field :failure, :string
    field :success, :string
    field :botch, :string
    field :book, :string
    field :page, :integer
    field :tools, :string
  end

  @required_fields ~w(id applications name description encumbrance_default category check cost_factor quality failure success botch book page)a
  @optional_fields ~w(encumbrance_conditional tools)a

  @doc false
  def changeset(skill, attrs) do
    skill
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_number(:id, greater_than: 0)
    |> validate_length(:name, min: 5, max: 30)
    |> validate_inclusion(:category, SkillCategory.values())
    |> validate_inclusion(:cost_factor, CostFactor.values())
    |> validate_check()
    |> unique_constraint(:name)
  end
  require Logger
  defp validate_check(changeset) do
    case changeset do
      %Ecto.Changeset{changes: %{check: check}} ->
        with [t1, t2, t3] <- String.split(check, "/"),
          n1 when not is_nil(n1) <- Enum.find_index(@traits, & &1 == t1),
          n2 when not is_nil(n2) <- Enum.find_index(@traits, & &1 == t2),
          n3 when not is_nil(n3) <- Enum.find_index(@traits, & &1 == t3)
        do
          changeset
        else
          _ -> add_error(changeset, :check, dgettext("errors", "invalid check format"))
        end

      _ ->
        changeset
    end
  end
end
