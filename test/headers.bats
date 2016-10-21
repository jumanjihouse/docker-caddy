load env
@test "securityheaders.io shows A+" {
  if [[ -z $HAS_INBOUND_PORT_80 ]]; then
    skip "define HAS_INBOUND_PORT_80 in test/env.bash to run this test"
  fi
  public_ip=$(curl -sS https://icanhazip.com/)
  grade=$(curl -sS -I -X HEAD "https://securityheaders.io/?q=${public_ip}" | awk '/X-Grade/ {print $NF}')
  [[ $grade == "A+" ]]
}
