#!/bin/bash

iptables -t nat -A POSTROUTING -o eth0 -s 10.14.0.0/24 -j MASQUERADE && iptables -A FORWARD -i ocserv0 -o eth0 -j ACCEPT && iptables -A FORWARD -i eth0 -o ocserv0 -j ACCEPT

ip6tables -t nat -A POSTROUTING -o eth0 -s fda9:4efe:7e3b:03ea::/48 -j MASQUERADE && ip6tables -A FORWARD -i ocserv0 -o eth0 -j ACCEPT && ip6tables -A FORWARD -i eth0 -o ocserv0 -j ACCEPT

ocserv -f -c /etc/ocserv/ocserv.conf -d 4
