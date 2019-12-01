#!/usr/bin/env sh
#
# initialize server profile
#

set -e

if [ -f "/etc/tinc/${NETNAME}/hosts/server" ]; then
  echo 'Initialized!'
  exit 0
else
  echo 'Initializing...'
fi

if [ -z "${IP_ADDR}" ]; then
  echo "IP_ADDR not set. Exiting."
fi

export NETNAME="${NETNAME:-tinc-network}"
export ADDRESS="${ADDRESS:-10.0.0.1}"
export NETMASK="${NETMASK:-255.255.255.0}"
export NETWORK="${NETWORK:-10.0.0.0/24}"
export RUNMODE="${RUNMODE:-server}"
export VERBOSE="${VERBOSE:-0}"

echo "Starting with the settings:"
echo "---------------------------"
echo "IP_ADDR: ${IP_ADDR}"
echo "NETNAME: ${NETNAME}"
echo "ADDRESS: ${ADDRESS}"
echo "NETMASK: ${NETMASK}"
echo "NETWORK: ${NETWORK}"
echo "RUNMODE: ${RUNMODE}"
echo "VERBOSE: ${VERBOSE}"
echo "---------------------------"

tinc -n "${NETNAME}" init server

cat > "/etc/tinc/${NETNAME}/tinc.conf" <<_EOF_
Name = server
Interface = tun0
_EOF_

cat > "/etc/tinc/${NETNAME}/tinc-up" <<_EOF_
#!/bin/sh
ip link set \$INTERFACE up
ip addr add ${ADDRESS} dev \$INTERFACE
ip route add ${NETWORK} dev \$INTERFACE
_EOF_

cat > "/etc/tinc/${NETNAME}/tinc-down" <<_EOF_
#!/bin/sh
ip route del ${NETWORK} dev \$INTERFACE
ip addr del ${ADDRESS} dev \$INTERFACE
ip link set \$INTERFACE down
_EOF_

chmod +x "/etc/tinc/${NETNAME}/tinc-up" "/etc/tinc/${NETNAME}/tinc-down"
