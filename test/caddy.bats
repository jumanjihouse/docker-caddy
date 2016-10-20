@test "caddy image exists" {
  run docker images
  [[ $output =~ jumanjiman/caddy ]]
}

@test "caddy is running on the test port" {
  run docker logs caddy
  [[ $output =~ 0.0.0.0:2020 ]]
}
