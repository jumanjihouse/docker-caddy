@test "upload plugin is present" {
  run docker run --rm -t --entrypoint=caddy jumanjiman/caddy -plugins
  [[ $output =~ http.upload ]]
}

@test "upload works" {
  rm -f /tmp/myrelease || :
  ip=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' caddy)
  curl -T /etc/os-release http://${ip}:2020/uploads/myrelease
  curl -o /tmp/myrelease http://${ip}:2020/myrelease
  cmp /tmp/myrelease /etc/os-release
  [[ $status -eq 0 ]]
}
