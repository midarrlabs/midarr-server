FROM node:18-alpine as node

WORKDIR /assets

COPY assets/package.json assets/package-lock.json /assets/
RUN npm install

#-------------------------

FROM elixir:1.15-otp-25-alpine

ARG MIX_ENV="dev"
ARG SECRET_KEY_BASE=""

ENV MIX_ENV="${MIX_ENV}"
ENV SECRET_KEY_BASE="${SECRET_KEY_BASE}"

WORKDIR /app

COPY . ./
COPY --from=node /assets/node_modules /app/assets/node_modules/

RUN \
    echo "https://dl-cdn.alpinelinux.org/alpine/v3.18/main" > /etc/apk/repositories \
    && echo "https://dl-cdn.alpinelinux.org/alpine/v3.18/community" >> /etc/apk/repositories \
    && apk update

RUN \
    apk add --no-cache --virtual=.build-deps \
        build-base \
    && \
    apk add --no-cache \
        ca-certificates \
        inotify-tools \
        postgresql15-client \
        curl \
        make \
        g++ \
        git \
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
