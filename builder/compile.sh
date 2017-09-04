#!/bin/sh
set -ex

# https://github.com/mholt/caddy/issues/1843
go get github.com/caddyserver/buildworker

source /home/developer/CADDY_VERSION
go get -d github.com/mholt/caddy
cd /home/developer/src/github.com/mholt/caddy
git checkout ${CADDY_VERSION}

# Note: I created these patches with...
#   git diff --no-color --no-prefix
#
# Add one or more plugins.
patch -p0 -i /home/developer/plugins.patch

# https://github.com/niemeyer/gopkg/issues/50
git config --global http.https://gopkg.in.followRedirects true

# Fetch dependencies.
go get -d ./...

# Build!
mkdir /home/developer/bin/
cd caddy
go run build.go

cp /home/developer/src/github.com/mholt/caddy/caddy/caddy /home/developer/bin/

# http://www.thegeekstuff.com/2012/09/strip-command-examples/
strip --strip-all /home/developer/bin/caddy
