setup() {
  ip=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' caddy)
}

@test "upload plugin is present" {
  run docker run --rm -t --entrypoint=caddy jumanjiman/caddy -plugins
  [[ $output =~ http.upload ]]
}

@test "upload works" {
  rm -f /tmp/myrelease || :
  curl -T /etc/os-release http://${ip}:2020/uploads/myrelease
  curl -o /tmp/myrelease http://${ip}:2020/myrelease
  cmp /tmp/myrelease /etc/os-release
  [[ $status -eq 0 ]]
}

@test "move works" {
  curl -X MOVE -H "Destination: /uploads/newrelease" http://${ip}:2020/uploads/myrelease
  curl -o /tmp/newrelease http://${ip}:2020/newrelease
  cmp /tmp/myrelease /tmp/newrelease
  [[ $status -eq 0 ]]
}

@test "head is forbidden" {
  run curl --fail --head http://${ip}:2020/ 2>&1
  [[ $output =~ 405 ]]
}
