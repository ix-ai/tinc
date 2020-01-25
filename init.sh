#!/usr/bin/env bash
#
# initialize server profile
#

set -e
if [ ! "${VERBOSE}" = "0" ]; then
  set -x
fi

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

  cat >> "/etc/tinc/${NETNAME}/hosts/server" <<_EOF_
Address = ${IP_ADDR}
_EOF_

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

if [ -f "/etc/tinc/${NETNAME}/tinc.conf" ]; then
  echo 'tinc is already initialized!'
else
  echo 'Initializing tinc...'
  _init_tinc
fi
