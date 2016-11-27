setup() {
  docker-compose run --rm clean
}

@test "upload plugin is present" {
  run docker-compose run --rm caddy -plugins
  [[ $output =~ http.upload ]]
}

@test "upload works" {
  run docker-compose run --rm curl --fail -sS -T /etc/os-release http://192.168.254.254:2020/uploads/myrelease
  run docker-compose run --rm curl --fail -sS -o /tmp/myrelease http://192.168.254.254:2020/myrelease
  run docker-compose run --rm cmp /tmp/myrelease /etc/os-release
  [[ $status -eq 0 ]]
}

@test "move works" {
  run docker-compose run --rm curl --fail -sS -X MOVE -H "Destination: /uploads/newrelease" http://192.168.254.254:2020/uploads/myrelease
  run docker-compose run --rm curl --fail -sS -o /tmp/newrelease http://192.168.254.254:2020/newrelease
  run docker-compose run --rm cmp /tmp/newrelease /etc/os-release
  [[ $status -eq 0 ]]
}

@test "head is forbidden" {
  run docker-compose run --rm curl --fail -sS --head http://192.168.254.254:2020/ 2>&1
  [[ $output =~ 405 ]]
}

@test "authenticated upload works" {
  KEYID="zween"
  SECRET="upload"
  TIMESTAMP="$(date --utc +%s)"
  TOKEN="ABC"

  SIGNATURE="$(printf "${TIMESTAMP}${TOKEN}" |
    openssl dgst -binary -sha256 -hmac "${SECRET}" |
    openssl enc -base64)"

  run docker-compose run --rm curl --fail -sS \
    --header "Timestamp: \"${TIMESTAMP}\"" \
    --header "Token: \"${TOKEN}\"" \
    --header "Authorization: Signature keyId=\"${KEYID}\",signature=\"${SIGNATURE}\"" \
    --upload-file /etc/resolv.conf \
    http://192.168.254.254:2020/authenticated_uploads/myresolv

  run docker-compose run --rm curl --fail -sS -o /tmp/myresolv http://192.168.254.254:2020/myresolv
  run cmp /tmp/myresolv /etc/resolv.conf
  [[ $status -eq 0 ]]
}
