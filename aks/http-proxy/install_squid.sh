#!/bin/bash

sudo apt-get update
sudo apt-get install squid -y

mv /etc/squid/squid.conf /etc/squid/squid.conf.bak

echo "acl SSL_ports port 443
acl Safe_ports port 80          # http
acl Safe_ports port 21          # ftp
acl Safe_ports port 443         # https
acl Safe_ports port 70          # gopher
acl Safe_ports port 210         # wais
acl Safe_ports port 1025-65535  # unregistered ports
acl Safe_ports port 280         # http-mgmt
acl Safe_ports port 488         # gss-http
acl Safe_ports port 591         # filemaker
acl Safe_ports port 777         # multiling http
acl CONNECT method CONNECT

http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access allow all

http_port 3128" > /etc/squid/squid.conf

sudo systemctl restart squid
sudo systemctl status squid