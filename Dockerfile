FROM node:18-alpine as node

WORKDIR /assets

COPY assets/package.json assets/package-lock.json /assets/
RUN npm install

#-------------------------

FROM elixir:1.14.3-otp-24-alpine

ARG MIX_ENV="dev"
ARG SECRET_KEY_BASE=""

ENV MIX_ENV="${MIX_ENV}"
ENV SECRET_KEY_BASE="${SECRET_KEY_BASE}"

RUN MIX_ENV=$MIX_ENV
RUN SECRET_KEY_BASE=$SECRET_KEY_BASE

WORKDIR /app

COPY . ./
COPY --from=node /assets/node_modules /app/assets/node_modules/

RUN \
    apk add --no-cache --virtual=.build-deps \
        build-base \
    && \
    apk add --no-cache \
        ca-certificates \
        ffmpeg \
        inotify-tools \
        postgresql15-client \
    && \
    mix local.hex --force \
    && mix local.rebar --force \
    && mix deps.get \
    && mix deps.compile \
    && mix assets.deploy \
    && mix compile \
    && apk del --purge .build-deps \
    && rm -rf /tmp/* \
    && chmod u+x /app/entry.sh

EXPOSE 4000

CMD [ "/app/entry.sh" ]
