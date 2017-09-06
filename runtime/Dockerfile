FROM alpine:3.6

ARG CI_BUILD_URL
ARG BUILD_DATE
ARG VCS_REF
ARG CADDY_VERSION

LABEL \
    io.github.jumanjiman.ci-build-url=$CI_BUILD_URL \
    io.github.jumanjiman.version=$CADDY_VERSION \
    io.github.jumanjiman.build-date=$BUILD_DATE \
    io.github.jumanjiman.vcs-ref=$VCS_REF \
    io.github.jumanjiman.license="Apache License 2.0" \
    io.github.jumanjiman.docker.dockerfile="/runtime/Dockerfile" \
    io.github.jumanjiman.vcs-type="Git" \
    io.github.jumanjiman.vcs-url="https://github.com/jumanjihouse/docker-caddy.git"

RUN apk upgrade --no-cache --available && \
    apk add --no-cache \
      ca-certificates \
      git \
      libressl \
      openssh-client \
    && adduser -Du 1000 caddy

RUN echo "hello world" > /home/caddy/index.html
COPY caddyfile /etc/caddy/

RUN \
    mkdir -p /var/www && \
    chown caddy:caddy /var/www && \
    :

VOLUME ["/etc/caddy"]
VOLUME ["/var/www"]

COPY caddy /usr/sbin/caddy

# Run as an unprivileged user.
USER caddy
ENTRYPOINT ["/usr/sbin/caddy"]
CMD ["-conf", "/etc/caddy/caddyfile"]
