#!/bin/bash

while ! pg_isready -q -h $DB_HOSTNAME -U $DB_USERNAME
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

if [[ -z `psql -Atqc "\\list $DB_DATABASE"` ]]; then

  mix local.hex --force
  mix local.rebar --force
  mix deps.get
  mix compile
  mix assets.deploy

  mix ecto.migrate
  mix run priv/repo/seeds.exs
  echo "Database $DB_DATABASE ready"
fi

exec mix phx.server