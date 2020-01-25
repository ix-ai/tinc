FROM debian:buster
LABEL maintainer="docker@ix.ai" \
      ai.ix.repository="ix.ai/tinc"

COPY init.sh /init.sh
COPY entrypoint.sh /entrypoint.sh
COPY peer.sh /usr/local/bin/peer.sh
COPY tinc-sudoers /etc/sudoers.d/tinc

ARG NETNAME="tinc-network"
ARG ADDRESS="192.168.218.1"
ARG SUBNET_BITS="24"
ARG SERVER_NAME="server"
ARG RUNMODE="server"
ARG VERBOSE="0"

RUN /bin/chmod 755 /init.sh && \
    /bin/chmod 755 /entrypoint.sh && \
    /bin/chmod 755 /usr/local/bin/peer.sh && \
    /bin/chmod 440 /etc/sudoers.d/tinc && \
    /bin/mkdir -p /etc/tinc && \
    /bin/echo "deb http://deb.debian.org/debian experimental main" > /etc/apt/sources.list.d/experimental.list && \
    /usr/bin/apt-get update && \
    /usr/bin/apt-get install -y --no-install-recommends -t experimental tinc && \
    /usr/bin/apt-get install -y --no-install-recommends iptables sudo && \
    /bin/rm -rf /var/lib/apt/lists/* && \
    /usr/sbin/useradd --comment 'tinc VPN' --no-create-home --user-group -s /usr/sbin/nologin --uid 1001 tinc && \
    /bin/chown tinc:tinc /etc/tinc

VOLUME /etc/tinc

ENV NETNAME ${NETNAME}
ENV ADDRESS ${ADDRESS}
ENV SUBNET_BITS ${SUBNET_BITS}
ENV SERVER_NAME ${SERVER_NAME}
ENV RUNMODE ${RUNMODE}
ENV VERBOSE ${VERBOSE}

EXPOSE 655/tcp 655/udp

ENTRYPOINT ["/entrypoint.sh"]
