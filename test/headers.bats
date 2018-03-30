load env
@test "securityheaders.io shows A" {
  if [[ -z $HAS_INBOUND_PORT_80 ]]; then
    skip "define HAS_INBOUND_PORT_80 in test/env.bash to run this test"
  fi
  public_ip=$(curl --fail -sS https://icanhazip.com/)
  grade="$(
    curl --fail -sS -I -X HEAD "https://securityheaders.io/?q=${public_ip}" |
    awk 'BEGIN { IGNORECASE=1 } /^X-Grade/ { print $NF }'
  )"
  # securityheaders.io caps grade at "A" because we don't use https.
  # However, the test harness doesn't use https because we run the
  # test harness on somebody else's infrastructure (circleci) and
  # therefore have no control of dns and so forth.
  [[ $grade == "A" ]]
}

@test "do not reveal server software name" {
  run docker-compose run --rm curl -i http://192.168.254.253:2020/
  ! [[ $output =~ sponsors ]]
}
