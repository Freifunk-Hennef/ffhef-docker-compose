#!/bin/bash
set -ex

function splitGreTunnel {
    TUNNEL_NAME=$(echo $1 | jq -r '.name')
    TUNNEL_ENDPOINT=$(echo $1 | jq -r '.tunnel_endpoint')
    TUNNEL_ADDRESS_IPV4=$(echo $1 | jq -r '.tunnel_address_ipv4')
    TUNNEL_PEER_IPV4=$(echo $1 | jq -r '.tunnel_peer_ipv4')
}

function splitBgpNeighbor {
    NEIGHBOR_NAME=$(echo $1 | jq -r '.name')
    NEIGHBOR_AS=$(echo $1 | jq -r '.as')
    NEIGHBOR_ADDRESS_IPV4=$(echo $1 | jq -r '.address_ipv4')
    NEIGHBOR_SOURCE_IPV4=$(echo $1 | jq -r '.source_ipv4')
}

# Set up public IPv4 address on loopback interface
ip address add ${BIRD_IPV4_PUBLIC_ADDRESS}/32 dev lo
ip rule add from ${MESH_IPV4} table 42
ip rule add to ${MESH_IPV4} table 42

TUNNEL_LOCAL=$(hostname -i | awk '{print $1}')

# Set up GRE tunnels
for GRE_TUNNEL_I in $(echo $GRE_TUNNELS | jq -r 'keys|@sh')
do
    GRE_TUNNEL="$(echo $GRE_TUNNELS | jq -c '.['$GRE_TUNNEL_I']')"
    splitGreTunnel $GRE_TUNNEL
    ip tunnel add $TUNNEL_NAME mode gre remote $TUNNEL_ENDPOINT ttl 64
    ip link set $TUNNEL_NAME mtu $GRE_TUNNEL_MTU
    ip link set $TUNNEL_NAME up
    ip addr add $TUNNEL_ADDRESS_IPV4/255.255.255.255 peer $TUNNEL_PEER_IPV4 dev $TUNNEL_NAME
    iptables -t nat -A POSTROUTING -o $TUNNEL_NAME -s $MESH_IPV4 -j SNAT --to-source $BIRD_IPV4_PUBLIC_ADDRESS
    if [ -z "$GRE_TUNNEL_MSS_CLAMP"]
    then
        iptables -A FORWARD -o $TUNNEL_NAME -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
    else
        iptables -A FORWARD -o $TUNNEL_NAME -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss $GRE_TUNNEL_MSS_CLAMP
    fi
    echo 2 > /proc/sys/net/ipv4/conf/$TUNNEL_NAME/rp_filter
done

# Only run if template exists
if [ -f "/etc/bird/bird.conf.in" ]
then

    # Create bird config snippet for BGP neighbors
    for BGP_NEIGHBOR_I in $(echo $BGP_NEIGHBORS | jq -r 'keys|@sh')
    do
        BGP_NEIGHBOR="$(echo $BGP_NEIGHBORS | jq -c '.['$BGP_NEIGHBOR_I']')"
        splitBgpNeighbor $BGP_NEIGHBOR
        BIRD_CONFIG_APPEND="$BIRD_CONFIG_APPEND

protocol bgp $NEIGHBOR_NAME from ffrl_peering {
    source address $NEIGHBOR_SOURCE_IPV4;
    neighbor $NEIGHBOR_ADDRESS_IPV4 as $NEIGHBOR_AS;
};"
    done
    export BIRD_CONFIG_APPEND
	envsubst < /etc/bird/bird.conf.in > /etc/bird/bird.conf
fi

cat /etc/bird/bird.conf

exec /usr/sbin/bird $@
