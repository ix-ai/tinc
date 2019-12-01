FROM debian:buster
LABEL maintainer="docker@ix.ai"

COPY init.sh /init.sh
COPY entrypoint.sh /entrypoint.sh
COPY peer.sh /usr/local/bin/peer.sh

RUN chmod 755 /init.sh && \
    chmod 755 /entrypoint.sh && \
    chmod 755 /peer.sh && \
    mkdir -p /etc/tinc && \
    echo "deb http://deb.debian.org/debian experimental main" > /etc/apt/sources.list.d/experimental.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends -t experimental tinc && \
    apt-get install -y --no-install-recommends iptables && \
    rm -rf /var/lib/apt/lists/*

VOLUME /etc/tinc

EXPOSE 655/tcp 655/udp

ENTRYPOINT ["/entrypoint.sh"]
