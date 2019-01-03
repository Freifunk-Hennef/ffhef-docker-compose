#!/bin/bash
set -ex

PUBLIC_IPV4=$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')

/sbin/ipvsadm --set 0 0 60
/sbin/ipvsadm -D -u $PUBLIC_IPV4:53774 || true
/sbin/ipvsadm -A -u $PUBLIC_IPV4:53774 -s lc

for (( fastd_instance=1; fastd_instance<=$FASTD_INSTANCES; fastd_instance++ ))
do
	#FASTD_INTERFACE_MAC
	export FASTD_INSTANCE=$fastd_instance
	FASTD_PORT=$(expr 10000 + $fastd_instance)
	/sbin/ipvsadm -a -u $PUBLIC_IPV4:53774 -r $PUBLIC_IPV4:$FASTD_PORT -m
	envsubst < /etc/fastd/fastd.conf.in > /etc/fastd/fastd_${fastd_instance}.conf
	export supervisord_config_append="$(echo -ne "$supervisord_config_append\n[program:fastd${fastd_instance}]\ncommand=/usr/bin/fastd --config /etc/fastd/fastd_${fastd_instance}.conf --log-level debug\n")"
done

envsubst < /etc/supervisord.conf.in > /etc/supervisord.conf

cat /etc/supervisord.conf



exec /usr/bin/supervisord -c /etc/supervisord.conf
