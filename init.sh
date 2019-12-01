#!/usr/bin/env bash
#
# initialize server profile
#

set -e

function _init_tinc() {
  if [ -z "${IP_ADDR}" ]; then
    echo "IP_ADDR not set. Exiting."
  fi

  echo "Initializing with the settings:"
  echo "---------------------------"
  echo "IP_ADDR: ${IP_ADDR}"
  echo "NETNAME: ${NETNAME}"
  echo "ADDRESS: ${ADDRESS}"
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
_EOF_

  chmod +x "/etc/tinc/${NETNAME}/tinc-up"
  chown -R tinc:tinc /etc/tinc
}

export NETNAME="${NETNAME:-tinc-network}"
export ADDRESS="${ADDRESS:-10.0.0.1/24}"
export RUNMODE="${RUNMODE:-server}"
export VERBOSE="${VERBOSE:-0}"

if [ -f "/etc/tinc/${NETNAME}/hosts/server" ]; then
  echo 'Initialized!'
else
  echo 'Initializing...'
  _init_tinc
fi
