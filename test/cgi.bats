@test "cgi plugin is installed" {
  run docker-compose run --rm caddy -plugins
  [[ $output =~ http.cgi ]]
}

@test "cgi script works" {
  run docker-compose run curl --fail -sS -L http://192.168.254.254:2020/hellocgi
  [[ $output =~ "hello, cgi world" ]]
}
