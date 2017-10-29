@test "file command is available" {
  run command -v file
  [[ $status -eq 0 ]]
}

@test "scanelf command is available" {
  run command -v scanelf
  [[ $status -eq 0 ]]
}

@test "caddy binary is stripped" {
  run file test/caddy
  [[ $output =~ stripped ]]
  [[ ! $output =~ 'not stripped' ]]
}

@test "caddy binary is statically compiled" {
  run scanelf -BF '%o#F' test/caddy
  [[ $output =~ ET_EXEC ]]

  run file test/caddy
  [[ $output =~ statically ]]
}
