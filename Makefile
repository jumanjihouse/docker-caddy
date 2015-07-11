# vim: set ts=8 sw=8 ai noet:
include CADDY_VERSION
date=$(shell date +%Y%m%dT%H%M)

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
	@docker build -t caddybuild -f Dockerfile.build .
	@docker create --name caddybuild caddybuild true
	@docker cp caddybuild:/home/developer/bin/caddy .

.PHONY: runtime
runtime: caddy
	@docker build -t jumanjiman/caddy -f Dockerfile.runtime .
	@docker images | grep caddy

.PHONY: test
test: stop
	@docker build --rm -t caddyfile -f fixtures/Dockerfile.config fixtures/
	@docker create --name caddyfile caddyfile true
	@docker images | grep caddy
ifdef CIRCLECI
	@docker run -d --name caddy --volumes-from caddyfile --read-only jumanjiman/caddy -conf /etc/caddy/caddyfile
else
	@docker run -d --name caddy --volumes-from caddyfile --read-only --cap-drop all jumanjiman/caddy -conf /etc/caddy/caddyfile
endif
	@docker logs caddy | grep '0.0.0.0:2020'

.PHONY: push
push:
	TAG1=${CADDY_VERSION}-${date}-git-${CIRCLE_SHA1:0:7}
	docker login -e ${mail} -u ${user} -p ${pass}
	docker tag jumanjiman/caddy jumanjiman/caddy:${TAG1}
	docker push jumanjiman/caddy:${TAG1}
	docker push jumanjiman/caddy:latest
	docker logout
