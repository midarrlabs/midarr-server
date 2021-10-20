FROM elixir:latest

RUN apt-get update && \
    apt-get install -y inotify-tools sqlite3

RUN mkdir /app
COPY . /app

WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix ecto.create

EXPOSE 4000

CMD ["mix", "phx.server"]