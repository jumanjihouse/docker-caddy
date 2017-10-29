# Must use go 1.9.0 or higher so "go get ./..." ignores the vendor folder.
# https://github.com/lucas-clemente/quic-go/issues/797
FROM golang:1.9.0-alpine

ENV GOPATH /home/developer
ENV CGO_ENABLED 0
ENV GOOS linux

RUN apk upgrade --no-cache --available && \
    apk add --no-cache \
      bash \
      binutils \
      ca-certificates \
      file \
      git \
      libressl-dev \
      musl-dev \
      patch \
      scanelf \
    && adduser -D developer

USER developer
WORKDIR /home/developer

# This file is where we define the caddy version.
# The caddy version becomes part of the docker tag in Makefile.
COPY . /home/developer/
