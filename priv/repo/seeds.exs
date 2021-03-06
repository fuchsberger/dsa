# Scripts for populating the database. You can them as:
# mix run priv/repo/seeds.exs

# This will update / insert all DSA data elements
# Alternatively Data elements are automatically inserted via migration.
Dsa.Repo.Seeder.seed()
