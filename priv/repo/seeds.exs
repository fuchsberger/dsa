# Scripts for populating the database. You can them as:
# mix run priv/repo/seeds.exs

# Also some admin conviencences are now supported via the interactive shell:
# iex -S mix

# Create an admin user:
# Dsa.Repo.Seeder.create_admin(email, password, username)

# Create a group:
# Dsa.Accounts.create_group(%{name: "<NAME>"})

# This will update / insert all DSA data elements
# Alternatively Data elements are automatically inserted via migration.
Dsa.Repo.Seeder.seed()
