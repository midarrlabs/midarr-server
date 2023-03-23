FROM node:18-alpine as node

WORKDIR /assets

COPY assets/package.json assets/package-lock.json /assets/
RUN npm install

#-------------------------

FROM elixir:1.14.3-otp-24

ARG MIX_ENV="dev"
ARG SECRET_KEY_BASE=""

ENV MIX_ENV="${MIX_ENV}"
ENV SECRET_KEY_BASE="${SECRET_KEY_BASE}"

RUN MIX_ENV=$MIX_ENV
RUN SECRET_KEY_BASE=$SECRET_KEY_BASE

RUN apt-get update
RUN apt-get install -y inotify-tools postgresql-client ffmpeg

WORKDIR /app

COPY . ./
COPY --from=node /assets/node_modules /app/assets/node_modules/

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get
RUN mix deps.compile
RUN mix assets.deploy
RUN mix compile

RUN chmod u+x /app/entry.sh

EXPOSE 4000

CMD [ "/app/entry.sh" ]