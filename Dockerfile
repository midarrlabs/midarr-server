FROM node:22-alpine as node

WORKDIR /assets

COPY assets/package.json assets/package-lock.json /assets/
RUN npm install

#-------------------------

FROM elixir:1.17-otp-26-alpine

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
    apk add --no-cache \
        build-base \
        cmake \
        ca-certificates \
        openssl \
        inotify-tools \
        postgresql15-client \
        curl \
        git \
    && \
    mix local.hex --force \
    && mix local.rebar --force \
    && mix deps.get \
    && mix deps.compile \
    && mix assets.deploy \
    && mix compile \
    && rm -rf /tmp/* \
    && chmod u+x /app/entry.sh

EXPOSE 4000

CMD [ "/app/entry.sh" ]
