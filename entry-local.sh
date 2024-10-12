#!/bin/sh

ln -s /app/dev/library/sample__1080__libx264__ac3__30s__video.mp4 /app/dev/library/movies/Night\ of\ the\ Living\ Dead\ \(1968\)/Night.Of.The.Living.Dead.1080p.mp4

curl -d "@dev/radarr/root-folder.json" -H "Content-Type:application/json" -X POST "http://radarr:7878/api/v3/rootfolder?apiKey=d031e8c9b9df4b2fab311d1c3b3fa2c5"
curl -d "@dev/radarr/movies.json" -H "Content-Type:application/json" -X POST "http://radarr:7878/api/v3/movie/import?apiKey=d031e8c9b9df4b2fab311d1c3b3fa2c5"

ln -s /app/dev/library/sample__1080__libx264__ac3__30s__video.mp4 /app/dev/library/series/Pioneer\ One/Season\ 1/Pioneer.One.S01E01.Earthfall.720p.mp4
ln -s /app/dev/library/sample__1080__libx264__ac3__30s__video.mp4 /app/dev/library/series/Pioneer\ One/Season\ 1/Pioneer.One.S01E02.The.Man.From.Mars.720p.mp4
ln -s /app/dev/library/sample__1080__libx264__ac3__30s__video.mp4 /app/dev/library/series/Pioneer\ One/Season\ 1/Pioneer.One.S01E03.Alone.in.the.Night.720p.mp4

curl -d "@dev/sonarr/root-folder.json" -H "Content-Type:application/json" -X POST "http://sonarr:8989/api/v3/rootfolder?apikey=1accda4476394bfcaddefe8c4fd77d4a"
curl -d "@dev/sonarr/series.json" -H "Content-Type:application/json" -X POST "http://sonarr:8989/api/v3/series/import?apikey=1accda4476394bfcaddefe8c4fd77d4a"

mix deps.get

while ! pg_isready -q -h $DB_HOSTNAME -U $DB_USERNAME
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

if [[ -z `psql -Atqc "\\list $DB_DATABASE"` ]]; then
  mix ecto.migrate
  mix run priv/repo/seeds.exs
  echo "Database $DB_DATABASE ready"
fi

mix phx.server