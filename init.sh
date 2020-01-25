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
  echo "SUBNET_BITS: ${SUBNET_BITS}"
  echo "RUNMODE: ${RUNMODE}"
  echo "VERBOSE: ${VERBOSE}"
  echo "---------------------------"

  tinc -n "${NETNAME}" init "${SERVER_NAME}"

  cat >> "/etc/tinc/${NETNAME}/hosts/${SERVER_NAME}" <<_EOF_
Address = ${IP_ADDR}
Digest = sha512
_EOF_

  cat > "/etc/tinc/${NETNAME}/tinc.conf" <<_EOF_
Name = ${SERVER_NAME}
Interface = tun0
_EOF_

  cat > "/etc/tinc/${NETNAME}/tinc-up" <<_EOF_
#!/bin/sh
sudo /sbin/ip link set \$INTERFACE up
sudo /sbin/ip addr add ${ADDRESS}/${SUBNET_BITS} dev \$INTERFACE
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
