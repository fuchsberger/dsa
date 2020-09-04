# Scripts for populating the database. You can them as:
# mix run priv/repo/seeds.exs (regenerates armors and weapons)


alias Dsa.{Accounts, Repo}

# Create Admin User
{:ok, alex} = Accounts.register_user(%{
  admin: true,
  name: "Alex",
  username: "admin",
  password: "p#7NDQ2y@0^f#WS3$j3u5@jPUjWcRlws"
})

# Create Admin User
{:ok, testuser} = Accounts.register_user(%{
  name: "Test",
  username: "test",
  password: "testtest"
})

{:ok, group} =
  %Accounts.Group{}
  |> Accounts.Group.changeset(%{ name: "DSA", master_id: alex.id })
  |> Repo.insert()

Accounts.create_character(alex, %{
  name: "Rolo",
  species: "Mensch",
  culture: "Mittelreich",
  profession: "Raubritter",
  group_id: group.id
})

Accounts.create_character(testuser, %{
  name: "Test1",
  species: "Mensch",
  culture: "Mittelreich",
  profession: "Testcharacter",
  group_id: group.id
})
