# Scripts for populating the database. You can them as:
# mix run priv/repo/seeds.exs

# Also some admin conviencences are now supported via the interactive shell:
# iex -S mix

# Create an user:
# {:ok, user} = Dsa.Accounts.register_user(%{username: "Username", password: "password", password_confirm: "password", email: "test@test.com"})

# Make user an admin
# Dsa.Accounts.manage_user!(user, %{admin: true, confirmed: true, token: nil})

# Create a group:
# Dsa.Accounts.create_group(%{name: "group_name"})

# This will update / insert all DSA data elements
# Alternatively Data elements are automatically inserted via migration.
Dsa.Data.Seeder.seed()
