FROM debian:bookworm-slim

RUN apt update && \
    apt upgrade -y && \
    apt install --no-install-recommends -y \
    ca-certificates \
    net-tools \
    iptables \
    ocserv

WORKDIR /
COPY entrypoint.sh .

ENTRYPOINT [ "/entrypoint.sh" ]
