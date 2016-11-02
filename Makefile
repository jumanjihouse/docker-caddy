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
	@docker rm -f caddybuild || :
	@docker run --name caddybuild caddybuild /home/developer/compile.sh
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
	@touch test/env.bash
	@docker build --rm -t caddyfile -f fixtures/Dockerfile.config fixtures/
	@docker create --name caddyfile caddyfile true
ifdef CIRCLECI
	@docker run -d \
		--name caddy \
		--volumes-from caddyfile \
		--read-only \
		-p 80:2020 \
		jumanjiman/caddy -conf /etc/caddy/caddyfile
else
	@docker run -d \
		--name caddy \
		--volumes-from caddyfile \
		--read-only \
		-p 80:2020 \
		--cap-drop all \
		jumanjiman/caddy -conf /etc/caddy/caddyfile
endif
	sleep 5
	bats test/*.bats


.PHONY: push
push:
	docker tag jumanjiman/caddy jumanjiman/caddy:${TAG1}
	@docker login -e ${mail} -u ${user} -p ${pass}
	docker push jumanjiman/caddy:${TAG1}
	docker push jumanjiman/caddy:latest
	@docker logout
