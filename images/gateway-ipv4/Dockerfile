FROM ffhef/debian-batman:9.4-2018.1

MAINTAINER Nico - Freifunk Hennef <nico@freifunk-hennef.de>

ENV MESH_IPV4=""
ENV BIRD_IPV4_ROUTER_ID=""
ENV BIRD_AS=""
ENV BIRD_IPV4_PUBLIC_NET=""
ENV BIRD_IPV4_PUBLIC_ADDRESS=""
ENV BIRD_CONFIG_APPEND=""
ENV GRE_TUNNELS=""
ENV GRE_TUNNEL_MSS_CLAMP=""
ENV GRE_TUNNEL_MTU=1400
ENV BGP_NEIGHBORS=""

RUN apt-get update && apt-get install -y bird iptables tcpdump jq && apt-get clean && \
    rm -rf /var/lib/apt/lists /tmp/* /var/tmp/* && \
    mkdir -p /run/bird

ADD /bird.conf.in /etc/bird/bird.conf.in
ADD /entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "-f", "-u", "bird", "-g", "bird" ]
