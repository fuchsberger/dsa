# Scripts for populating the database. You can them as:
# mix run priv/repo/seeds.exs (regenerates armors and weapons)

alias Dsa.Accounts

# Create Admin User
{:ok, admin} = Accounts.register_user(%{
  admin: true,
  email: "admin@fuchsberger.us",
  username: "Alex",
  password: "p#7NDQ2y@0^f#WS3$j3u5@jPUjWcRlws"
})

# Create Test User
{:ok, user} = Accounts.register_user(%{
  email: "test@fuchsberger.us",
  username: "test",
  password: "testtest"
})

Accounts.create_group(%{ name: "DSA", master_id: admin.id })
Accounts.create_character(admin)
Accounts.create_character(user)
