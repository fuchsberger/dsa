# Scripts for populating the database. You can them as:
# mix run priv/repo/seeds.exs

# Also some admin conviencences are now supported via the interactive shell:
# iex -S mix

# Make a user an administrator:
# Dsa.Repo.Seeder.make_admin("<EMAIL>")

# Confirms a user:
# Dsa.Repo.Seeder.confirm("<EMAIL>")

# This will update / insert all DSA data elements
# Alternatively Data elements are automatically inserted via migration.
Dsa.Repo.Seeder.seed()

Dsa.Accounts.create_group(%{name: "Völs"})
