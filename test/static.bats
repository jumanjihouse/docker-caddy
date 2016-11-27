@test "file command is available" {
  run command -v file
  [[ $status -eq 0 ]]
}

@test "scanelf command is available" {
  run command -v scanelf
  [[ $status -eq 0 ]]
}

@test "caddy binary is stripped" {
  run file runtime/caddy
  [[ $output =~ stripped ]]
}

@test "caddy binary is statically compiled" {
  run scanelf -BF '%o#F' runtime/caddy
  [[ $output =~ ET_EXEC ]]

  run file runtime/caddy
  [[ $output =~ statically ]]
}
