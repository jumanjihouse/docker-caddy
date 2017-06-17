@test "caddy image exists" {
  run docker images
  [[ $output =~ jumanjiman/caddy ]]
}

@test "caddy is running on the test port" {
  run docker-compose logs caddy1
  [[ $output =~ 0.0.0.0:2020 ]]
}

@test "caddy2 is running on the test port" {
  run docker-compose logs caddy2
  [[ $output =~ 0.0.0.0:2020 ]]
}
