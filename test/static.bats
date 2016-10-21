@test "caddy binary is stripped" {
  run docker run --rm caddybuild file /home/developer/bin/caddy
  [[ $output =~ stripped ]]
}

@test "caddy binary is statically compiled" {
  run docker run --rm caddybuild scanelf -BF '%o#F' /home/developer/bin/caddy
  [[ $output =~ ET_EXEC ]]

  run docker run --rm caddybuild file /home/developer/bin/caddy
  [[ $output =~ statically ]]
}
