defmodule Dsa.Repo do
  use Ecto.Repo, otp_app: :dsa, adapter: Ecto.Adapters.Postgres

  import Ecto.Changeset, only: [validate_format: 3]

  @mail_regex ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/

  def validate_email(changeset, field), do: validate_format(changeset, field, @mail_regex)
end
