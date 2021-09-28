# wildfly14vpn
Image uses AdoptOpenJDK 8 (8u172) installed on ubuntu as a first layer. 
https://github.com/AdoptOpenJDK/openjdk-docker/blob/master/8/jdk/ubuntu/Dockerfile.hotspot.releases.full

Next layer installs Wildfly 14 and Openconnect.

Java EE8, Java 8 

Recommended way to use this image is to build your application in to next layer using own docker image like this:
```yml
FROM dryseawind/wildfly14jdk8

ADD ./deployments /opt/jboss/wildfly-14.0.1.Final/standalone/deployments (for deploying your war)

ENV VPN_URL="https://vpn_link"
ENV VPN_USER="utente"
ENV VPN_PASSWORD="passowrd"
ENV END_POINT_CHECK="https://endpoint"

CMD ["/opt/jboss/wildfly-14.0.1.Final/bin/standalone.sh", "-c", "standalone.xml", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0" , "--debug"]
```

# Use container with docker-compose
```yml
wildfly-vpn:
  container_name: wildfly14vpn
  image: posapiano/wildfly14vpn:latest
  privileged: true
  env_file:
    - VPN_URL: "https://vpn_link"
    - VPN_USER: "utente"
    - VPN_PASSWORD: "passowrd"
    - END_POINT_CHECK: "https://endpoint"
  ports:
    - 9990:8080
    - 8080:9990
  networks:
    - mynetwork
```

# Start/Stop/Status vpn
run in bash shell
```bash
# Start 
/opt/vpn/startVpn.sh
# Stop
/opt/vpn/stopVpn.sh
# Status
/opt/vpn/vpnStatus.sh
```
Status Vpn is:
* `0` connected
* `1` disconnected

Docker hub: https://hub.docker.com/r/posapiano/wildfly14vpn

