# Based on adopt openjdk 8
FROM adoptopenjdk/openjdk8:jdk8u172-b11
LABEL maintainer="posapiano-ops rfiorito@outlook.it"

ENV WILDFLY_VERSION 14.0.1.Final
ENV WILDFLY_SHA1 757d89d86d01a9a3144f34243878393102d57384
ENV JBOSS_HOME /opt/jboss/wildfly-14.0.1.Final
ENV JBOSS_INSTALL /opt/jboss
ENV config_dir=/opt/jboss/wildfly-14.0.1.Final/standalone/configuration/

ENV DOCKERVERSION=19.03.15 

USER root
RUN apt update \
     && apt install -y curl telnet net-tools \ 
     && rm -rf /var/lib/apt/lists/*

RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
  && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 -C /usr/local/bin docker/docker \
  && rm docker-${DOCKERVERSION}.tgz

RUN mkdir -p /opt/vpn
COPY ./script/*.sh /opt/vpn/
RUN chmod +x /opt/vpn/*.sh

RUN groupadd -r jboss -g 1000 && useradd -u 1000 -r -g jboss -m -d /opt/jboss -s /sbin/nologin -c "JBoss user" jboss && \
    chmod 755 /opt/jboss

# Add the WildFly distribution to /opt, and make wildfly the owner of the extracted tar content
# Make sure the distribution is available from a well-known place
RUN cd $HOME \
    && curl -O https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz \
    && sha1sum wildfly-$WILDFLY_VERSION.tar.gz | grep $WILDFLY_SHA1 \
    && tar xf wildfly-$WILDFLY_VERSION.tar.gz \
    && mv $HOME/wildfly-$WILDFLY_VERSION $JBOSS_INSTALL \
    && rm wildfly-$WILDFLY_VERSION.tar.gz \
    && chown -R jboss:0 ${JBOSS_INSTALL} \
    && chmod -R g+rw ${JBOSS_INSTALL}

#COPY standalone.xml ${config_dir}
ENV LAUNCH_JBOSS_IN_BACKGROUND true

#USER jboss

# Allow mgmt console access to "root" group
RUN rmdir /opt/jboss/wildfly-14.0.1.Final/standalone/tmp/auth && \
    mkdir -p /opt/jboss/wildfly-14.0.1.Final/standalone/tmp/auth && \
    chmod 775 /opt/jboss/wildfly-14.0.1.Final/standalone/tmp/auth

# Expose the ports we're interested in
EXPOSE 8080
EXPOSE 9990

# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to all interface
CMD ["/opt/jboss/wildfly-14.0.1.Final/bin/standalone.sh","-c","standalone.xml","-b","0.0.0.0","-bmanagement", "0.0.0.0"]

