#!/bin/bash
kill -15 $(pidof openconnect)
cat > /etc/resolv.conf <<EOF
nameserver 127.0.0.11
options ndots:0
EOF
