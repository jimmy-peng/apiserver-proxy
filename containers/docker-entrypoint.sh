#!/bin/sh
set -e -x

sed -ri "s|ACI_SVC_GW|${ACI_SVC_GW%.*}.12|" /haproxy.cfg
sed -ri "s|APIC_HOST|${APIC_HOST}|" /haproxy.cfg

until curl -k -s https://kubernetes.kubernetes.rancher.internal:6443; do
    echo "Wait apiserver"
    sleep 1
done

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- haproxy "$@"
fi

if [ "$1" = 'haproxy' ]; then
	shift # "haproxy"
	# if the user wants "haproxy", let's add a couple useful flags
	#   -W  -- "master-worker mode" (similar to the old "haproxy-systemd-wrapper"; allows for reload via "SIGUSR2")
	#   -db -- disables background mode
	set -- haproxy -W -db "$@"
fi

exec "$@"
