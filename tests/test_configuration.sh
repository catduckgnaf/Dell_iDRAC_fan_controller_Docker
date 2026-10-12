#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."
source configuration.sh

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

(
  unset IDRAC_HOST IDRAC_USERNAME IDRAC_PASSWORD FAN_SPEED CPU_TEMPERATURE_THRESHOLD CHECK_INTERVAL
  unset DISABLE_THIRD_PARTY_PCIE_CARD_DELL_DEFAULT_COOLING_RESPONSE
  unset KEEP_THIRD_PARTY_PCIE_CARD_COOLING_RESPONSE_STATE_ON_EXIT

  load_configuration

  [[ $FAN_SPEED == 5 ]] || fail "default FAN_SPEED was not applied"
  [[ $FAN_SPEED_CONFIGURATION_SOURCE == default ]] || fail "default source was not reported"
)

(
  export FAN_SPEED=45

  load_configuration

  [[ $FAN_SPEED == 45 ]] || fail "runtime FAN_SPEED was overwritten"
  [[ $FAN_SPEED_CONFIGURATION_SOURCE == environment ]] || fail "environment source was not reported"
)

echo "configuration tests passed"
