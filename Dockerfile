FROM debian:buster
LABEL maintainer="docker@ix.ai"

COPY init.sh /init.sh
COPY entrypoint.sh /entrypoint.sh
COPY peer.sh /usr/local/bin/peer.sh

RUN /bin/chmod 755 /init.sh && \
    /bin/chmod 755 /entrypoint.sh && \
    /bin/chmod 755 /usr/local/bin/peer.sh && \
    /bin/mkdir -p /etc/tinc && \
    /bin/echo "deb http://deb.debian.org/debian experimental main" > /etc/apt/sources.list.d/experimental.list && \
    /usr/bin/apt-get update && \
    /usr/bin/apt-get install -y --no-install-recommends -t experimental tinc && \
    /usr/bin/apt-get install -y --no-install-recommends iptables && \
    /bin/rm -rf /var/lib/apt/lists/*

VOLUME /etc/tinc

EXPOSE 655/tcp 655/udp

ENTRYPOINT ["/entrypoint.sh"]
