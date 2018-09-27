@test "cache plugin is installed" {
  run docker-compose run --rm caddy -plugins
  [[ "${output}" =~ http.cache ]]
}

@test "can fetch a proxied asset" {
  curl_opts='--user-agent assets --fail -sS -L'

  output="$(docker-compose run curl ${curl_opts} http://192.168.254.254:2020/assets/)" # cache miss
  [[ "${output}" =~ 'hello world' ]]

  output="$(docker-compose run curl ${curl_opts} http://192.168.254.254:2020/assets/)" # cache hit
  [[ "${output}" =~ 'hello world' ]]
}

@test "log shows cache hits and misses" {
  output="$(docker-compose logs caddy1 | grep -e assets)"
  [[ "${output}" =~ miss ]]
  [[ "${output}" =~ hit ]]
}
