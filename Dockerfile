FROM elixir:latest

RUN apt-get update && \
    apt-get install -y inotify-tools postgresql-client ffmpeg

RUN mkdir /app

COPY . /app

WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get

EXPOSE 4000

CMD [ "mix", "phx.server" ]