Caddy web server
================

[![Download size](https://images.microbadger.com/badges/image/jumanjiman/caddy.svg)](http://microbadger.com/images/jumanjiman/caddy "View on microbadger.com")
[![Version](https://images.microbadger.com/badges/version/jumanjiman/caddy.svg)](http://microbadger.com/images/jumanjiman/caddy "View on microbadger.com")
[![Source code](https://images.microbadger.com/badges/commit/jumanjiman/caddy.svg)](http://microbadger.com/images/jumanjiman/caddy "View on microbadger.com")
[![Docker Registry](https://img.shields.io/docker/pulls/jumanjiman/caddy.svg)](https://registry.hub.docker.com/u/jumanjiman/caddy/)&nbsp;
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
* [caddy-upload](https://github.com/wmark/caddy.upload)

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

The above command builds a `caddybuild` image, which builds
a static binary. It then copies the static binary
out of the build image and creates a runtime image, `caddy`.

The runtime image does not have developer tools or source code.
The runtime image is based on Alpine, not Scratch, to enable
plugins that depend on external tools, such as `git`.


### Test

We use circleci to build, test, and publish the image to Docker hub.
We use [BATS](https://github.com/sstephenson/bats) to run the test harness.

Output of `make test` resembles:

    ✓ caddy image exists
    ✓ caddy is running on the test port
    ✓ git plugin is installed
    ✓ git plugin works
    - securityheaders.io shows A+ (skipped: define HAS_INBOUND_PORT_80 in test/env.bash to run this test)
    - ci-build-url label is present (skipped: This test only runs on CircleCI)
    ✓ caddy binary is stripped
    ✓ caddy binary is statically compiled
    ✓ upload plugin is present
    ✓ upload works
    ✓ move works
    ✓ head is forbidden

    12 tests, 0 failures, 2 skipped

The test harness uses an example caddyfile at [`fixtures/caddyfile`](fixtures/caddyfile)
to demonstrate ways to secure a Caddy-based site according to
good industry practices.
The test harness does not use TLS at the moment.

The securityheaders.io test requires inbound access from the internet to port 80.
If you have inbound access and want to run the securityheaders.io test,
create `test/env.bash` like this:

    HAS_INBOUND_PORT_80=true


### Pull an already-built image

    # Note: build tags follow the pattern
    # jumanjiman/caddy:${CADDY_VERSION}-${BUILD_DATE}T${BUILD_TIME}-git-${HASH}
    docker pull jumanjiman/caddy


### View labels

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
