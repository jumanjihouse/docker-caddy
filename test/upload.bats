setup() {
  docker-compose run --rm clean
}

@test "head is forbidden" {
  run docker-compose run --rm curl --fail -sS --head http://192.168.254.254:2020/ 2>&1
  [[ $output =~ 405 ]]
}
