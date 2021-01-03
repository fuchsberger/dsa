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

{:ok, benni} = Accounts.register_user(%{
  email: "benni@fuchsberger.us",
  username: "Benni",
  password: "password"
})

{:ok, berni} = Accounts.register_user(%{
  email: "berni@fuchsberger.us",
  username: "Börni",
  password: "password"
})

{:ok, burns} = Accounts.register_user(%{
  email: "burns@fuchsberger.us",
  username: "Burns",
  password: "password"
})

{:ok, dani} = Accounts.register_user(%{
  email: "dani@fuchsberger.us",
  username: "Dani",
  password: "password"
})

{:ok, group} = Accounts.create_group(%{ name: "Völs", master_id: alex.id })

Accounts.create_character(alex, %{
  name: "Andrej", profession: "Raubritter",
  mu: 14, kl: 11, in: 13, ch: 9, ff: 10, ge: 14, ko: 15, kk: 16
})

Accounts.create_character(alex, %{
  name: "Ethric", profession: "Elementarmagier",
  mu: 13, kl: 16, in: 14, ch: 14, ff: 10, ge: 10, ko: 13, kk: 10
})

Accounts.create_character(burns, %{
  name: "Faelandel", profession: "Former",
  mu: 12, kl: 12, in: 14, ch: 11, ff: 14, ge: 15, ko: 13, kk: 12
})

Accounts.create_character(burns, %{
  name: "Farsid", profession: "Phexgeweihter",
  mu: 13, kl: 12, in: 14, ch: 11, ff: 13, ge: 15, ko: 15, kk: 11
})

Accounts.create_character(dani, %{
  name: "Horathio", profession: "Borongeweihter",
  mu: 15, kl: 13, in: 13, ch: 12, ff: 10, ge: 11, ko: 13, kk: 15
})

Accounts.create_character(berni, %{
  name: "Torax?", profession: "bitte eintragen"
})

Accounts.create_character(benni, %{
  name: "Shannon", profession: "bitte eintragen"
})
