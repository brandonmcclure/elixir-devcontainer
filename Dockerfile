ARG TARGET_ELIXER_TAG

# Dockerfile
FROM $TARGET_ELIXER_TAG as build
ARG TARGET_ELIXER_TAG

RUN mkdir /app
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force && \
	apk add inotify-tools
# set build ENV
ENV MIX_ENV=dev