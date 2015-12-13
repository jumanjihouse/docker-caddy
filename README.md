Caddy web server
================

[![Image Size](https://img.shields.io/imagelayers/image-size/jumanjiman/caddy/latest.svg)](https://imagelayers.io/?images=jumanjiman/caddy:latest 'View image size and layers')&nbsp;
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
and builds a tiny docker image.

See [http://blog.gopheracademy.com/caddy-a-look-inside/]
(http://blog.gopheracademy.com/caddy-a-look-inside/)
and [https://caddyserver.com/](https://caddyserver.com/)
to learn about Caddy.


License
-------

See [LICENSE.md](https://github.com/jumanjihouse/docker-caddy/blob/master/LICENSE.md)
in this git repo.


How-to
------

### Build

:warning: Build requires Docker 1.6.0 or later (for `docker build -f <dockerfile>`).

    make all

The above command builds a `caddybuild` image, which uses
[caddyext](https://github.com/caddyserver/caddyext)
to build a static binary. It then copies the static binary
out of the build image and creates a runtime image, `caddy`.
`caddyext` makes it easy to add middleware to the static binary.

The runtime image does not have developer tools or source code.


### Pull an already-built image

    # All tags, where each tag follows the pattern
    # jumanjiman/caddy:${CADDY_VERSION}-${BUILD_DATE}T${BUILD_TIME}-git-${HASH}
    docker pull -a jumanjiman/caddy


### Run

Create a config in some directory on your host, then:

    docker run -d \
    -p 2020:2020 \
    --name caddy \
    -v /path/to/configdir:/etc/caddy \
    --read-only \
    --cap-drop all \
    jumanjiman/caddy -conf /etc/caddy/caddyfile
