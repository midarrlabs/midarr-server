FROM node:18-alpine as node

WORKDIR /assets

COPY assets/package.json assets/package-lock.json .
RUN npm install

#-------------------------

FROM elixir:1.13

RUN apt-get update && \
    apt-get install -y inotify-tools postgresql-client

WORKDIR /app
COPY . .
COPY --from=node /assets/node_modules assets

ARG MIX_ENV="dev"
ARG SECRET_KEY_BASE=""

ENV MIX_ENV="${MIX_ENV}"
ENV SECRET_KEY_BASE="${SECRET_KEY_BASE}"

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get

RUN chmod u+x script-entry-point.sh

EXPOSE 4000

CMD [ "script-entry-point.sh" ]