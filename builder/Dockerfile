FROM alpine:3.5

ENV GOPATH /home/developer
ENV CGO_ENABLED 0
ENV GOOS linux

RUN apk upgrade --no-cache --available && \
    apk add --no-cache \
      bash \
      ca-certificates \
      file \
      git \
      'go>=1.7' \
      libressl-dev \
      musl-dev \
      scanelf \
    && adduser -D developer

USER developer
WORKDIR /home/developer

# This file is where we define the caddy version.
# The caddy version becomes part of the docker tag in Makefile.
COPY . /home/developer/
