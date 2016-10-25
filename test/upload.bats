setup() {
  ip=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' caddy)
  rm -f /tmp/*release
}

@test "upload plugin is present" {
  run docker run --rm -t --entrypoint=caddy jumanjiman/caddy -plugins
  [[ $output =~ http.upload ]]
}

@test "upload works" {
  curl --fail -sS -T /etc/os-release http://${ip}:2020/uploads/myrelease
  curl --fail -sS -o /tmp/myrelease http://${ip}:2020/myrelease
  run cmp /tmp/myrelease /etc/os-release
  [[ $status -eq 0 ]]
}

@test "move works" {
  curl --fail -sS -X MOVE -H "Destination: /uploads/newrelease" http://${ip}:2020/uploads/myrelease
  curl --fail -sS -o /tmp/newrelease http://${ip}:2020/newrelease
  run cmp /tmp/newrelease /etc/os-release
  [[ $status -eq 0 ]]
}

@test "head is forbidden" {
  run curl --fail -sS --head http://${ip}:2020/ 2>&1
  [[ $output =~ 405 ]]
}
