# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Dsa.Repo.insert!(%Dsa.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# Also some admin conviencences are now supported via the interactive shell:
# iex -S mix

# Make user an admin
# "user@example.abc" |> Dsa.Accounts.get_user_by_email() |> Dsa.Accounts.make_admin()
