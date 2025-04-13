FROM fedora:latest

RUN dnf update -y && \
    dnf install -y ocserv ca-certificates iptables && \
    dnf clean all && \
    mkdir -p /var/lib/ocserv/run && \
    chmod 755 /var/lib/ocserv/run && \
    chown ocserv:ocserv /var/lib/ocserv/run


WORKDIR /
COPY entrypoint.sh .

ENTRYPOINT [ "/entrypoint.sh" ]
