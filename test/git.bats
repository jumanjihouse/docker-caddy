@test "git plugin is installed" {
  run docker-compose run --rm caddy -plugins
  [[ $output =~ http.git ]]
}

@test "git plugin works" {
  run docker-compose logs caddy1 2>&1
  [[ $output =~ 'https://github.com/jumanjihouse/docker-caddy.git pulled' ]]
}

@test "can browse docker-caddy path" {
  run docker-compose run curl --fail -sS -L http://192.168.254.254:2020/docker-caddy
  [[ $output =~ README.md ]]
  [[ $output =~ LICENSE   ]]
  [[ $output =~ fixtures  ]]
}
