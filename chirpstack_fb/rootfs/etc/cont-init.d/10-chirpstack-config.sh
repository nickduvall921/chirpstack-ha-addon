#!/usr/bin/with-contenv bashio
# Builds the ChirpStack config on every start from the add-on options and
# the MQTT login the Supervisor hands out for the Mosquitto add-on.
set -e

if ! bashio::services.available "mqtt"; then
    bashio::exit.nok "No MQTT broker found. Install and start the Mosquitto broker add-on, then start this add-on again."
fi

mkdir -p /data/redis

# The API secret signs ChirpStack logins and API keys. Make it once and keep it.
if [ ! -s /data/api_secret ]; then
    bashio::log.info "Creating the ChirpStack API secret"
    head -c 32 /dev/urandom | base64 > /data/api_secret
    chmod 600 /data/api_secret
fi

export CS_CONF_DIR=/run/chirpstack
export GWB_CONF_DIR=/run/chirpstack-gateway-bridge
export DATA_DIR=/data
export API_SECRET="$(cat /data/api_secret)"
export MQTT_HOST="$(bashio::services mqtt 'host')"
export MQTT_PORT="$(bashio::services mqtt 'port')"
export MQTT_USER="$(bashio::services mqtt 'username')"
export MQTT_PASSWORD="$(bashio::services mqtt 'password')"
export LOG_LEVEL="$(bashio::config 'log_level')"

/usr/local/bin/render-chirpstack-config

bashio::log.info "ChirpStack config written (region us915_1, MQTT ${MQTT_HOST}:${MQTT_PORT})"
