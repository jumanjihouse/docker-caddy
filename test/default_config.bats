setup() {
  ip=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' caddy2)
}

@test "see hello world with default config" {
  run curl --fail -sS -L http://${ip}:2020/
  [[ $output =~ "hello world" ]]
}
