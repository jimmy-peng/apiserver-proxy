#!/bin/bash
set -x

sed -ri "s|ACI_SVC_GW|${ACI_SVC_GW%.*}.12|" /etc/nginx/nginx.conf
sed -ri "s|APIC_HOST|${APIC_HOST}|" /etc/nginx/nginx.conf

if ! /sbin/ip link | grep ${UPLINK_IFACE}"."${KUBEAPI_VLAN};then
    /sbin/ip a a ${API_SERVER_IP}"/"${ACI_NODE_SUBNET#*/} dev eth0
fi


until curl -k -s https://kubernetes.kubernetes.rancher.internal:6443; do
    echo "Wait apiserver"
    sleep 1
done



nginx -g "daemon off;"
