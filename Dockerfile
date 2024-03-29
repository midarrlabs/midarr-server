FROM node:18-alpine as node

WORKDIR /assets

COPY assets/package.json assets/package-lock.json /assets/
RUN npm install

#-------------------------

FROM elixir:1.15-otp-24-alpine

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
    echo "@latest https://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories \
    &&  echo "https://dl-cdn.alpinelinux.org/alpine/v3.11/main" >> /etc/apk/repositories \
    &&  echo "https://dl-cdn.alpinelinux.org/alpine/v3.12/community" >> /etc/apk/repositories \
    && echo "https://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "@edge-community https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
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
        "libva-intel-driver@edge-community=2.4.1-r0" \
        "shaderc@edge-community=2023.7-r0" \
        libdav1d \
        spirv-tools \
        "ffmpeg@latest=6.1.1-r0" \
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
