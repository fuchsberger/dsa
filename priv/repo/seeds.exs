# Scripts for populating the database. You can them as:
# mix run priv/repo/seeds.exs (regenerates armors and weapons)

alias Dsa.Accounts

# Create Admin User
{:ok, alex} = Accounts.register_user(%{
  admin: true,
  email: "admin@fuchsberger.us",
  username: "Alex",
  password: "p#7NDQ2y@0^f#WS3$j3u5@jPUjWcRlws"
})

{:ok, group} = Accounts.create_group(%{ name: "Völs", master_id: alex.id })

Accounts.create_character(alex, %{name: "Andrej", profession: "Raubritter"})
Accounts.create_character(alex, %{name: "Ethric", profession: "Elementarmagier"})
