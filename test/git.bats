@test "git plugin is installed" {
  run docker run --rm -t --entrypoint=caddy jumanjiman/caddy -plugins
  [[ $output =~ http.git ]]
}

@test "git plugin works" {
  run docker logs caddy 2>&1
  [[ $output =~ 'https://github.com/jumanjihouse/docker-caddy.git pulled' ]]
}
