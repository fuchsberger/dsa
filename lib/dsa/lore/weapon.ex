defmodule Dsa.Lore.Weapon do
  use Ecto.Schema

  import Ecto.Changeset
  import Dsa.Lists

  schema "weapons" do
    field :name, :string
    field :tp_dice, :integer
    field :tp_bonus, :integer
    field :l1, :string
    field :l2, :string
    field :ls, :integer
    field :at_mod, :integer
    field :pa_mod, :integer
    field :rw, :integer
    field :rw2, :integer
    field :rw3, :integer
    field :lz, :integer

    belongs_to :combat_skill, Dsa.Lore.CombatSkill
  end

  @fields ~w(id name tp_dice tp_bonus l1 l2 ls at_mod pa_mod rw rw2 rw3 lz combat_skill_id)a
  @required ~w(id name tp_dice tp_bonus rw combat_skill_id)a

  def changeset(weapon, attrs) do
    weapon
    |> cast(attrs, @fields)
    |> validate_required(@required)
    |> validate_required_combat()
    |> validate_length(:name, max: 25)
    |> validate_number(:tp_dice, greater_than_or_equal_to: 1, less_than_or_equal_to: 3)
    |> validate_number(:tp_dice, greater_than_or_equal_to: 0, less_than: 10)
    |> validate_inclusion(:l1, base_value_options())
    |> validate_inclusion(:l2, base_value_options())
    |> validate_number(:ls, greater_than_or_equal_to: 10)
    |> validate_number(:at_mod, greater_than_or_equal_to: -6, less_than_or_equal_to: 6)
    |> validate_number(:pa_mod, greater_than_or_equal_to: -6, less_than_or_equal_to: 6)
    |> validate_number(:rw, greater_than: 0, less_than_or_equal_to: 50)
    |> validate_number(:rw, greater_than: 0, less_than_or_equal_to: 100)
    |> validate_number(:rw, greater_than: 0, less_than_or_equal_to: 200)
    |> validate_number(:lz, greater_than_or_equal_to: 1)
  end

  @required_meele ~w(l1 ls at_mod pa_mod)a
  @required_distance ~w(rw2 rw3 lz)a

  defp validate_required_combat(weapon) do
    case get_field(weapon, :combat_skill_id) do
      nil ->
        validate_required(weapon, @required_meele)

      id ->
        combat_skill = Dsa.Repo.get(Dsa.Lore.CombatSkill, id)

        case combat_skill && combat_skill.ranged do
          true -> validate_required(weapon, @required_distance)
          false -> validate_required(weapon, @required_meele)
        end
    end
  end
end
