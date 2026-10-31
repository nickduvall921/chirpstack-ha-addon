# ChirpStack LoRaWAN

Runs the [ChirpStack](https://www.chirpstack.io/) LoRaWAN network server and
its gateway bridge inside Home Assistant, set up for Canada and the US:
**US915, sub-band 2** (channels 8–15 + 65).

It contains:

- **ChirpStack 4.20.0** (SQLite build). Its web interface opens from the
  ChirpStack entry in the Home Assistant sidebar, which also works through
  Home Assistant's remote access, and on port 8080 on the local network.
- **ChirpStack Gateway Bridge 4.1.2**, listening for gateways on **UDP 1700**
  (the Semtech UDP packet forwarder that TEKTELIC KONA gateways use).
- **Redis**, local to the add-on.

Both ChirpStack programs are the official builds from artifacts.chirpstack.io,
checked against pinned SHA-256 sums when the add-on is built.

## Before you start

Install and start the **Mosquitto broker** add-on. This add-on gets its MQTT
login from Home Assistant automatically, so no MQTT username or password is
entered here.

## First start

1. Start the add-on and open the log. Wait for `Starting ChirpStack`.
2. Click **Open web UI** (or ChirpStack in the sidebar), or go to
   `http://<home-assistant-ip>:8080` on the local network.
3. Log in with **admin / admin** and change the password straight away
   (top right → Change password).

## Connecting a gateway

On the gateway, point the packet forwarder at Home Assistant's IP address,
port 1700 up and down. On a TEKTELIC KONA with BSP 4.x, that is
`server_address`, `serv_port_up` and `serv_port_down` in
`/etc/default/config.json`, then `/etc/init.d/pkt_fwd restart`.

In ChirpStack, add the gateway under **Gateways** using its Gateway ID (EUI).
It shows as online once the first stats message arrives.

## Data

Everything ChirpStack keeps (gateways, devices, keys, the API secret) is in
the add-on's `/data` folder and is included in Home Assistant backups. The
add-on stops briefly while a backup runs so the database copy is consistent.

## Ports

| Port | Use |
|---|---|
| 1700/udp | LoRa gateways. Keep it on the local network; never forward it from the internet. |
| 8080/tcp | ChirpStack web interface and API. Local network only unless put behind a login. |

## Options

| Option | Default | |
|---|---|---|
| `log_level` | `info` | `trace`, `debug`, `info`, `warn` or `error`, for both ChirpStack and the gateway bridge. |
