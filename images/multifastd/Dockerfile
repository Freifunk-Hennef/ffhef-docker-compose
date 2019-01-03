FROM ffhef/debian-batman:9.4-2018.1

MAINTAINER Nico - Freifunk Hennef <nico@freifunk-hennef.de>

ENV PACKAGES="fastd python2.7 ipvsadm supervisor"

ENV FASTD_PORT=10000
ENV FASTD_BIND_ADDRESS=0.0.0.0
ENV FASTD_LOGLEVEL=info
ENV FASTD_MODE=tap
ENV FASTD_PEER_LIMIT=128
ENV FASTD_MTU=1406
ENV FASTD_INTERFACE_MAC=

RUN apt-get update && \
    apt-get install -y $PACKAGES && \
    curl -o /usr/local/bin/fastd-statistics https://raw.githubusercontent.com/ffrl/ff-tools/master/fastd/fastd-statistics.py && \
    chmod +x /usr/local/bin/fastd-statistics && \
    sed -i -e 's+^#!/.*+#!/usr/bin/python2.7+' /usr/local/bin/fastd-statistics && \
    apt-get clean && rm -rf /var/lib/apt/lists /tmp/* /var/tmp/*
    
EXPOSE 10000/udp

ADD /entrypoint.sh /
ADD /fastd.conf.in /etc/fastd/fastd.conf.in
ADD /supervisord.conf.in /etc/supervisord.conf.in

ENTRYPOINT [ "/entrypoint.sh" ]
