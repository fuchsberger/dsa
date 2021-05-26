# Dsa

To start your Phoenix server:

  * Setup the project with `mix setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Translation Instructions
```bash
mix gettext.extract
mix gettext.merge priv/gettext --locale de
```

## Additional mix tasks
Two additional mix tasks are available:
- `mix seed` Populates the database with DSA data
- `mix algolia` Syncronizes algolia search index with app data

## Deployment Instructions
After ssh into the production server this sequence will update the web application:

| Command | Condition |
| :-- | :-- |
| `cd ~/apps/dsa` | always |
| `git pull` | always |
| `mix deps.get --only prod` | hex dependencies have changed |
| `npm install --prefix ./assets` | npm dependencies have changed |
| `npm run deploy --prefix ./assets` | assets have changed |
| `mix phx.digest` | assets have changed |
| `MIX_ENV=prod mix ecto.migrate` | new database migrations (*) |
| `MIX_ENV=prod mix compile` | always |
| `MIX_ENV=prod mix release` | always |
| `sudo systemctl restart app_dsa.service` | always |

(*) if there are database migrations the server needs to be stopped and afterwards restarted:
```bash
sudo systemctl stop app_dsa.service
MIX_ENV=prod mix ecto.migrate
sudo systemctl start app_dsa.service
```
