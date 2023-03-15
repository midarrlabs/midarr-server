#!/bin/bash

mix deps.get
mix ecto.migrate
mix run priv/repo/seeds.exs

curl -d "@priv/radarr/root-folder.json" -H "Content-Type:application/json" -X POST "http://radarr:7878/api/v3/rootfolder?apiKey=d031e8c9b9df4b2fab311d1c3b3fa2c5"
curl -d "@priv/radarr/movies.json" -H "Content-Type:application/json" -X POST "http://radarr:7878/api/v3/movie/import?apiKey=d031e8c9b9df4b2fab311d1c3b3fa2c5"

curl -d "@priv/sonarr/root-folder.json" -H "Content-Type:application/json" -X POST "http://sonarr:8989/api/v3/rootfolder?apikey=1accda4476394bfcaddefe8c4fd77d4a"
curl -d "@priv/sonarr/series.json" -H "Content-Type:application/json" -X POST "http://sonarr:8989/api/v3/series/import?apikey=1accda4476394bfcaddefe8c4fd77d4a"

mix phx.server