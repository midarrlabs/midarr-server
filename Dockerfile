FROM elixir:latest

RUN apt-get update && \
    apt-get install -y inotify-tools postgresql-client

RUN mkdir /app
COPY . /app
WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix compile && \
    mix assets.deploy

RUN chmod u+x /app/entry-point.sh

EXPOSE 4000

CMD [ "/app/entry-point.sh" ]