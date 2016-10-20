#!/bin/sh
set -ex

source /home/developer/CADDY_VERSION
go get -d github.com/mholt/caddy
cd /home/developer/src/github.com/mholt/caddy
git checkout ${CADDY_VERSION}

# Note: I created these patches with...
#   git diff --no-color --no-prefix
#
# Add one or more plugins.
patch -p0 -i /home/developer/plugins.patch
#
# https://bugs.alpinelinux.org/issues/6072
patch -p0 -i /home/developer/static.patch

# Fetch dependencies.
go get -d ./...

# Build!
mkdir /home/developer/bin/
cd caddy
./build.bash /home/developer/bin/caddy

# Check that binary is static.
cd /home/developer
file bin/caddy
scanelf -BF '%o#F' bin/caddy | grep '^ET_EXEC$'
