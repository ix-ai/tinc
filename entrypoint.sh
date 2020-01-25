#!/usr/bin/env bash

set -e

if [ ! "${VERBOSE}" = "0" ]; then
  set -x
fi

. init.sh

if [ ! -c /dev/net/tun ]; then
    mkdir -p /dev/net
    mknod /dev/net/tun c 10 200
fi

if [ "${RUNMODE}" = "server" ]; then
    iptables -t nat -A POSTROUTING -s "${ADDRESS}/${SUBNET_BITS}" -o eth0 -j MASQUERADE
fi

set -x

exec tincd --no-detach \
           --net="${NETNAME}" \
           --debug="${VERBOSE}" \
           --user=tinc \
           "$@"
