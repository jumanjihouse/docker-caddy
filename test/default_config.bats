@test "see hello world with default config" {
  run docker-compose run --rm curl --fail -ssL http://192.168.254.253:2020/
  [[ $output =~ "hello world" ]]
}
