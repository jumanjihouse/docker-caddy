# vim: set ts=8 sw=8 ai noet:
include builder/CADDY_VERSION
date=$(shell date +%Y%m%dT%H%M)
hash=$(shell git rev-parse --short HEAD)
TAG1=${CADDY_VERSION}-${date}-git-${hash}

.PHONY: all
all: runtime

.PHONY: clean
clean:
	@rm -f caddy || :
	@docker rm -f caddybuild || :
	@docker rmi -f caddybuild || :

.PHONY: stop
stop:
	@docker rm -f caddy || :
	@docker rm -f caddyfile || :

caddy:
	@docker build -t caddybuild builder/
	@docker create --name caddybuild caddybuild true
	@docker cp caddybuild:/home/developer/bin/caddy runtime/

.PHONY: runtime
runtime: caddy
	@docker build \
		-t jumanjiman/caddy \
		--build-arg CI_BUILD_URL=${CIRCLE_BUILD_URL} \
		--build-arg VCS_REF=${hash} \
		--build-arg BUILD_DATE=${date} \
		--build-arg VERSION=${CADDY_VERSION} \
		runtime/
	@docker images | grep caddy

.PHONY: test
test: stop
	@docker build --rm -t caddyfile -f fixtures/Dockerfile.config fixtures/
	@docker create --name caddyfile caddyfile true
	@docker images | grep caddy
	@docker run --rm -t --entrypoint=caddy jumanjiman/caddy -plugins | grep http.git
ifdef CIRCLECI
	@docker inspect \
		-f '{{ index .Config.Labels "io.github.jumanjiman.ci-build-url" }}' \
		jumanjiman/caddy | grep circleci.com
	@docker run -d --name caddy --volumes-from caddyfile --read-only jumanjiman/caddy -conf /etc/caddy/caddyfile
else
	@docker run -d --name caddy --volumes-from caddyfile --read-only --cap-drop all jumanjiman/caddy -conf /etc/caddy/caddyfile
endif
	sleep 5
	@docker logs caddy 2>&1 | grep 'https://github.com/jumanjihouse/docker-caddy.git pulled'
	@docker logs caddy | grep '0.0.0.0:2020'
	bats test/upload.bats


.PHONY: push
push:
	docker tag jumanjiman/caddy jumanjiman/caddy:${TAG1}
	@docker login -e ${mail} -u ${user} -p ${pass}
	docker push jumanjiman/caddy:${TAG1}
	docker push jumanjiman/caddy:latest
	@docker logout
