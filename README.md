Caddy web server
================

[![Download size](https://images.microbadger.com/badges/image/jumanjiman/caddy.svg)](http://microbadger.com/images/jumanjiman/caddy "View on microbadger.com")
[![Version](https://images.microbadger.com/badges/version/jumanjiman/caddy.svg)](http://microbadger.com/images/jumanjiman/caddy "View on microbadger.com")
[![Source code](https://images.microbadger.com/badges/commit/jumanjiman/caddy.svg)](http://microbadger.com/images/jumanjiman/caddy "View on microbadger.com")
[![Docker Registry](https://img.shields.io/docker/pulls/jumanjiman/caddy.svg)](https://registry.hub.docker.com/u/jumanjiman/caddy/)&nbsp;
[![Circle CI](https://circleci.com/gh/jumanjihouse/docker-caddy.png?circle-token=cf57179da67e6644c2d6efee8b4612774a3bd29b)](https://circleci.com/gh/jumanjihouse/docker-caddy/tree/master 'View CI builds')

This project: https://github.com/jumanjihouse/docker-caddy/<br/>
Docker image: https://registry.hub.docker.com/u/jumanjiman/caddy/<br/>
Upstream Caddy: https://github.com/mholt/caddy/


About
-----

This git repo downloads golang source code from
https://github.com/mholt/caddy/
and builds a small docker image.

See http://blog.gopheracademy.com/caddy-a-look-inside/
and [https://caddyserver.com/](https://caddyserver.com/)
to learn about Caddy.


### Plugins

The following plugins are installed in the image:

* [http.cache](https://caddyserver.com/docs/http.cache)
* [http.cgi](https://github.com/jung-kurt/caddy-cgi)
* [http.git](https://github.com/abiosoft/caddy-git)
* [http.upload](https://github.com/wmark/caddy.upload)

See [`fixtures/caddyfile`](fixtures/caddyfile)
for an example config used to test this image.


License
-------

See [LICENSE.md](https://github.com/jumanjihouse/docker-caddy/blob/master/LICENSE.md)
in this git repo.


How-to
------

### Build

:warning: Build requires Docker CE 17.06.1 or higher (for multistage build).

    ci/build

The above command uses Docker multistage build to compile
a static binary. It then copies the static binary
out of the build image and creates a runtime image, `caddy`.

The runtime image does not have developer tools or source code.
The runtime image is based on Alpine, not Scratch, to enable
plugins that depend on external tools, such as `git`.


### Test

We use circleci to build, test, and publish the image to Docker hub.
We use [BATS](https://github.com/sstephenson/bats) to run the test harness.
We use [pre-commit](https://pre-commit.com/) to run various file checks.

Output of `ci/test` resembles:

    [forbid-binary] Forbid binaries..........................................(no files to check)Skipped
    [git-check] Check for conflict markers and core.whitespace errors............................Passed
    [git-dirty] Check if the git tree is dirty...................................................Passed
    [shellcheck] Test shell scripts with shellcheck..............................................Passed
    [yamllint] yamllint..........................................................................Passed
    [check-added-large-files] Check for added large files........................................Passed
    [check-case-conflict] Check for case conflicts...............................................Passed
    [check-executables-have-shebangs] Check that executables have shebangs.......................Passed
    [check-json] Check JSON..................................................(no files to check)Skipped
    [detect-private-key] Detect Private Key......................................................Passed
    [forbid-crlf] CRLF end-lines checker.........................................................Passed
    [forbid-tabs] No-tabs checker................................................................Passed

    ok caddy image exists
    ok caddy is running on the test port
    ok caddy2 is running on the test port
    ok cgi plugin is installed
    ok cgi script works
    ok see hello world with default config
    ok git plugin is installed
    ok git plugin works
    ok can browse docker-caddy path
    - securityheaders.io shows A (skipped: define HAS_INBOUND_PORT_80 in test/env.bash to run this test)
    ok do not reveal server software name
    - ci-build-url label is present (skipped: This test only runs on CircleCI)
    ok file command is available
    ok scanelf command is available
    ok caddy binary is stripped
    ok caddy binary is statically compiled
    ok upload plugin is present
    ok upload works
    ok move works
    ok head is forbidden

    20 tests, 0 failures, 2 skipped

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

Alternatively, use the minimal default [caddyfile](runtime/caddyfile) from the image
to just serve files from `/home/caddy`:

    docker run -d \
    -p 2020:2020 \
    --name caddy \
    --read-only \
    --cap-drop all \
    -v /path/to/your/files:/home/caddy:ro \
    jumanjiman/caddy -conf /etc/caddy/caddyfile
