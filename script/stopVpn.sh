#!/bin/bash
source /opt/vpn/unsetproxy.sh && \
docker stop vpn-proxy > /dev/null 2>&1
