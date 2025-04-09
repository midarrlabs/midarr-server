FROM elixir:1.18-otp-27-alpine

ARG MIX_ENV="dev"

ENV MIX_ENV="${MIX_ENV}"

WORKDIR /app
COPY . ./

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

EXPOSE 4000

CMD ["mix", "phx.server"]