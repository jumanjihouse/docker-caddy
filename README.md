Caddy web server
================

[![Download size](https://images.microbadger.com/badges/image/jumanjiman/caddy.svg)](http://microbadger.com/images/jumanjiman/caddy "View on microbadger.com")
[![Version](https://images.microbadger.com/badges/version/jumanjiman/caddy.svg)](http://microbadger.com/images/jumanjiman/caddy "View on microbadger.com")
[![Source code](https://images.microbadger.com/badges/commit/jumanjiman/caddy.svg)](http://microbadger.com/images/jumanjiman/caddy "View on microbadger.com")
[![Docker Registry](https://img.shields.io/docker/pulls/jumanjiman/caddy.svg)](https://registry.hub.docker.com/u/jumanjiman/caddy)&nbsp;
[![Circle CI](https://circleci.com/gh/jumanjihouse/docker-caddy.png?circle-token=cf57179da67e6644c2d6efee8b4612774a3bd29b)](https://circleci.com/gh/jumanjihouse/docker-caddy/tree/master 'View CI builds')

This project: [https://github.com/jumanjihouse/docker-caddy]
(https://github.com/jumanjihouse/docker-caddy)

Docker image: [https://registry.hub.docker.com/u/jumanjiman/caddy/]
(https://registry.hub.docker.com/u/jumanjiman/caddy/)

Upstream Caddy: [https://github.com/mholt/caddy]
(https://github.com/mholt/caddy)


About
-----

This git repo downloads golang source code from
[https://github.com/mholt/caddy]
(https://github.com/mholt/caddy)
and builds a small docker image.

See [http://blog.gopheracademy.com/caddy-a-look-inside/]
(http://blog.gopheracademy.com/caddy-a-look-inside/)
and [https://caddyserver.com/](https://caddyserver.com/)
to learn about Caddy.


### Plugins

The following plugins are installed in the image:

* [caddy-git](https://github.com/abiosoft/caddy-git)

See [`fixtures/caddyfile`](fixtures/caddyfile)
for an example config used to test this image.


License
-------

See [LICENSE.md](https://github.com/jumanjihouse/docker-caddy/blob/master/LICENSE.md)
in this git repo.


How-to
------

### Build

:warning: Build requires Docker 1.9.0 or later (for docker build args).

    make all

The above command builds a `caddybuild` image, which uses
[caddyext](https://github.com/caddyserver/caddyext)
to build a static binary. It then copies the static binary
out of the build image and creates a runtime image, `caddy`.
`caddyext` makes it easy to add middleware to the static binary.

The runtime image does not have developer tools or source code.
The runtime image is based on Alpine, not Scratch, to enable
middleware that depends on external tools, such as `git`.


### Pull an already-built image

    # All tags, where each tag follows the pattern
    # jumanjiman/caddy:${CADDY_VERSION}-${BUILD_DATE}T${BUILD_TIME}-git-${HASH}
    docker pull -a jumanjiman/caddy


### Labels

Each built image has labels that generally follow http://label-schema.org/

We add a label, `ci-build-url`, that is not currently part of the schema.
This extra label provides a permanent link to the CI build for the image.

View the ci-build-url label on a built image:

    docker inspect \
      -f '{{ index .Config.Labels "io.github.jumanjiman.ci-build-url" }}' \
      jumanjiman/caddy

Query all the labels inside a built image:

    docker inspect jumanjiman/caddy | jq -M '.[].Config.Labels'


### Run

Create a config in some directory on your host, then:

    docker run -d \
    -p 2020:2020 \
    --name caddy \
    -v /path/to/configdir:/etc/caddy \
    --read-only \
    --cap-drop all \
    jumanjiman/caddy -conf /etc/caddy/caddyfile
