Caddy web server
================

[![](https://badge.imagelayers.io/jumanjiman/caddy.svg)](https://imagelayers.io/?images=jumanjiman/caddy:latest 'View image size and layers')&nbsp;
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
