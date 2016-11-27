setup() {
  ip=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' caddy)
}

@test "git plugin is installed" {
  run docker run --rm -t --entrypoint=caddy jumanjiman/caddy -plugins
  [[ $output =~ http.git ]]
}

@test "git plugin works" {
  run docker logs caddy 2>&1
  [[ $output =~ 'https://github.com/jumanjihouse/docker-caddy.git pulled' ]]
}

@test "can browse docker-caddy path" {
  run curl --fail -sS -L http://${ip}:2020/docker-caddy
  [[ $output =~ README.md ]]
  [[ $output =~ LICENSE   ]]
  [[ $output =~ fixtures  ]]
}
