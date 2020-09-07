# Scripts for populating the database. You can them as:
# mix run priv/repo/seeds.exs (regenerates armors and weapons)

alias Dsa.{Accounts, Lore}

# Add DSA data
Lore.seed()

# Create Admin User
{:ok, admin} = Accounts.register_user(%{
  admin: true,
  name: "Alex",
  username: "admin",
  password: "p#7NDQ2y@0^f#WS3$j3u5@jPUjWcRlws"
})

# Create Test User
{:ok, user} = Accounts.register_user(%{
  name: "Test",
  username: "test",
  password: "testtest"
})

{:ok, group} = Accounts.create_group(%{ name: "DSA", master_id: admin.id })

Accounts.create_character(admin, %{
  name: "Rolo",
  species_id: 1,
  culture: "Mittelreich",
  profession: "Raubritter",
  group_id: group.id
})

Accounts.create_character(user, %{
  name: "Test1",
  species_id: 1,
  culture: "Mittelreich",
  profession: "Testcharacter",
  group_id: group.id
})
