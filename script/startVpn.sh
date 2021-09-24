#!/bin/bash
DOCKER_NETWORK_NAME=$(docker inspect ${HOSTNAME} -f '{{range $k,$v := .NetworkSettings.Networks}} {{$k}} {{end}}' | xargs )
CONTAINERID_EXIST=$(docker container ls -a --format "table {{.ID}}\t{{.Names}}" | grep vpn-proxy | cut -d" " -f1 )

#echo ${DOCKER_NETWORK_NAME}
#echo ${CONTAINERID_EXIST}

if [ ! -z ${CONTAINERID_EXIST} ]; then
   #source /opt/vpn/setproxy.sh && \
   docker container restart ${CONTAINERID_EXIST} > /dev/null 2>&1 
else
    #source /opt/vpn/setproxy.sh && \
    docker run --name=vpn-proxy --privileged -d -p 8888:8888 \
    --network=${DOCKER_NETWORK_NAME} \
    -e OPENCONNECT_URL=${VPN_URL} \
    -e OPENCONNECT_USER=${VPN_USER} \
    -e OPENCONNECT_PASSWORD=${VPN_PASSWORD} \
    wazum/openconnect-proxy > /dev/null 2>&1 
    
fi

