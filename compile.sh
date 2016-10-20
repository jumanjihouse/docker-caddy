#!/bin/sh
set -ex

# https://github.com/golang/go/issues/9344#issuecomment-69944514
source /home/developer/CADDY_VERSION
go get -d github.com/caddyserver/caddyext
cd /home/developer/src/github.com/caddyserver/caddyext
go build -a -installsuffix cgo -tags netgo -ldflags '-w' -o /home/developer/bin/caddyext
go get -d github.com/mholt/caddy
cd /home/developer/src/github.com/mholt/caddy
git checkout ${CADDY_VERSION}
cd /home/developer
bin/caddyext install git
bin/caddyext build bin/
mv bin/customCaddy bin/caddy
scanelf -BF '%o#F' bin/caddy | grep '^ET_EXEC$'
