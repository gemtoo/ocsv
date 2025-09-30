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

## VPN router Debian setup
1. To avoid wrapping LAN traffic into VPN, in config-per-user exclude routes to your LAN's prefix with no-route:
```
no-route = 10.1.0.0/16
no-route = 2a02:220e:2001:bb00::/56
```
2. Setup IPv4/IPv6 forwarding:
```
echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.d/99-openconnect-router.conf
echo 'net.ipv6.conf.all.forwarding = 1' >> /etc/sysctl.d/99-openconnect-router.conf
sysctl -p /etc/sysctl.d/99-openconnect-router.conf
```
3. Setup NAT and persistence:
```
iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
ip6tables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
apt install -y iptables-persistent
```
When installing iptables-persistence you'll be prompted to save IPv4 settings, then to save IPv6 settings, save them both.

## Notes
- By default the server uses `10.14.0.0/24` and `fd0e:1ced:c0ff:ee::/48` pools to give out addresses. If you need a different pool, change it in `entrypoint.sh` and `ocserv.conf`.