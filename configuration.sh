#!/bin/bash

# Apply defaults at container start rather than baking configurable values into
# the image metadata. Explicit Docker, Compose, and Unraid environment values
# therefore remain authoritative.
function set_configuration_default() {
  local -r VARIABLE_NAME="$1"
  local -r DEFAULT_VALUE="$2"
  local SOURCE_VARIABLE_NAME="${VARIABLE_NAME}_CONFIGURATION_SOURCE"

  if [[ -v $VARIABLE_NAME && -n "${!VARIABLE_NAME}" ]]; then
    printf -v "$SOURCE_VARIABLE_NAME" '%s' 'environment'
  else
    printf -v "$VARIABLE_NAME" '%s' "$DEFAULT_VALUE"
    export "$VARIABLE_NAME"
    printf -v "$SOURCE_VARIABLE_NAME" '%s' 'default'
  fi
}

function load_configuration() {
  set_configuration_default IDRAC_HOST local
  set_configuration_default IDRAC_USERNAME root
  set_configuration_default IDRAC_PASSWORD calvin
  set_configuration_default FAN_SPEED 5
  set_configuration_default CPU_TEMPERATURE_THRESHOLD 50
  set_configuration_default CHECK_INTERVAL 60
  set_configuration_default DISABLE_THIRD_PARTY_PCIE_CARD_DELL_DEFAULT_COOLING_RESPONSE false
  set_configuration_default KEEP_THIRD_PARTY_PCIE_CARD_COOLING_RESPONSE_STATE_ON_EXIT false
}
