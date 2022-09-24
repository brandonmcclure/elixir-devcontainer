ARG TARGET_ELIXER_TAG

# Dockerfile
FROM $TARGET_ELIXER_TAG as build
ARG TARGET_ELIXER_TAG

# set build ENV
ENV MIX_ENV=dev

RUN apk update
# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force && \
	apk add inotify-tools

RUN mix archive.install hex phx_new --force
WORKDIR /mnt
ENTRYPOINT [ "/bin/sh" ]

