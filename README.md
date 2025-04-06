# Dockerized OpenConnect VPN server

## Description
OpenConnect uses TLS for encrypting traffic. Using TLS makes this VPN a low profile one, that is able to bypass a Russian VPN censorship firewall. This VPN works on port 443 and can run behind a reverse proxy. For seamless experience it is recommended to use certificates from a trusted CA like Let's Encrypt. This repository makes it easy to setup OpenConnect VPN server that is running behind Traefik reverse proxy and leveraging Traefik's certificates.

## Prerequisites
- A Linux server.
- Docker knowledge + installed Docker + Docker Compose plugin.
- Traefik knowledge + Traefik running on the external Docker network named `web`. Network `web` should have IPv6 support if IPv6 is needed. Traefik should be able to work with labels of other containers and generate certificates according to those labels.

## How to run it?
- In the repository root create `.env` file. It should contain one string: `OCSV_DOMAIN=your-vpn-server-domain.com`
- Run the next command:
```
docker compose up -d
```
- After the stack is built and running, generate a user, in this case user's login will be `exampleloginname`. Then enter password for the new user.
```
docker exec -it ocsv ocpasswd -c /etc/ocserv/passwd exampleloginname
```
- Connect with any OpenConnect or Cisco AnyConnect client to your server. Endpoint address will be your `OCSV_DOMAIN`, login `exampleloginname` and password is the password that was set on the previous step.

## Notes
- By default the server uses `10.14.0.0/24` and `fda9:4efe:7e3b:03ea::/48` pools to give out addresses. If you need a different pool, change it in `entrypoint.sh` and `ocserv.conf`.
