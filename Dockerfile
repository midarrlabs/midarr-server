FROM node:18-alpine as node

WORKDIR /assets

COPY assets/package.json assets/package-lock.json /assets/
RUN npm install

#-------------------------

FROM elixir:1.14

ARG MIX_ENV="dev"
ARG SECRET_KEY_BASE=""

ENV MIX_ENV="${MIX_ENV}"
ENV SECRET_KEY_BASE="${SECRET_KEY_BASE}"

RUN MIX_ENV=$MIX_ENV
RUN SECRET_KEY_BASE=$SECRET_KEY_BASE

RUN apt-get update && \
    apt-get install -y inotify-tools sqlite3 ffmpeg

WORKDIR /app

COPY . ./
COPY --from=node /assets/node_modules /app/assets/node_modules/

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix deps.compile && \
    mix assets.deploy && \
    mix compile

RUN chmod u+x /app/support/entry-point.sh

EXPOSE 4000

CMD [ "/app/support/entry-point.sh" ]