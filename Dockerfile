FROM elixir:latest as elixir_base

RUN apt-get update && \
    apt-get install -y inotify-tools postgresql-client

RUN mkdir -p /opt/ffmpeg

COPY ./build/ffmpeg-git-amd64-static.tar.xz /opt/ffmpeg

RUN cd /opt/ffmpeg && \
    tar xvf ffmpeg-git-amd64-static.tar.xz && \
    cd ffmpeg-git-20211123-amd64-static && \
    ln -s "${PWD}/ffmpeg" /usr/local/bin/ && \
    ln -s "${PWD}/ffprobe" /usr/local/bin/

RUN mkdir /app

COPY . /app

FROM node:14.15.4 as node_dependencies
COPY --from=elixir_base /app /app
WORKDIR /app
RUN cd assets && \
    npm set progress=false && \
    npm config set depth 0 && \
    npm install

FROM elixir_base
COPY --from=node_dependencies /app /app
WORKDIR /app
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix assets.deploy && \
    mix run priv/repo/seeds.exs

EXPOSE 4000

CMD [ "mix", "phx.server" ]