#!/bin/sh
set -ex

# https://github.com/mholt/caddy/commit/3b144c21d01
# https://github.com/mholt/caddy/issues/1843
go get github.com/caddyserver/builds

source /home/developer/CADDY_VERSION
go get -d github.com/mholt/caddy
cd /home/developer/src/github.com/mholt/caddy
git checkout ${CADDY_VERSION}

# Note: I created these patches with...
#   git diff --no-color --no-prefix -U0
#
# The busybox version of patch doesn't understand unified diffs,
# so we have to use GNU patch.
#
# Add one or more plugins.
patch -p0 --unified -i /home/developer/plugins.patch

# https://github.com/niemeyer/gopkg/issues/50
git config --global http.https://gopkg.in.followRedirects true

# Fetch dependencies.
go get -d ./...

# Install go-getter.
cd /tmp
git clone https://github.com/joewalnes/go-getter.git
cp -f go-getter/go-getter /home/developer/
export PATH=${PATH}:/home/developer/bin/

# run go-getter after the deps have been fetched above
# https://github.com/joewalnes/go-getter
cd /home/developer && ./go-getter gofile

# Build!
mkdir /home/developer/bin/
cd /home/developer/src/github.com/mholt/caddy/caddy
go run build.go

cp /home/developer/src/github.com/mholt/caddy/caddy/caddy /home/developer/bin/

# http://www.thegeekstuff.com/2012/09/strip-command-examples/
strip --strip-all /home/developer/bin/caddy
