# Script for populating the database. You can run it as:
# mix run priv/repo/seeds.exs

alias Dsa.{Accounts, Game}

# Create Admin User
{:ok, alex} = Accounts.register_user(%{
  name: "Alex Fuchsberger",
  username: "admin",
  password: "p#7NDQ2y@0^f#WS3$j3u5@jPUjWcRlws"
})

Accounts.set_role(alex, :admin, true)

{:ok, group} = Game.create_group( %{name: "DSA", master_id: alex.id})

Game.create_character(alex, %{
  name: "Rolo",
  species: "Mensch",
  culture: "Mittelreich",
  profession: "Rondrageweihter",
  group_id: group.id
})

Game.create_character(alex, %{
  name: "Sam",
  species: "Elf",
  culture: "Auelf",
  profession: "Wildnisläufer",
  group_id: group.id
})
