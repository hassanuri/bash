#!/bin/bash
#
# add this script to cron cron: 
# @reboot /home/scripts/forward.sh
# 
ENDPOINT=`/usr/bin/aws elasticache describe-cache-clusters --show-cache-node-info  | grep Address | cut -d ':' -f 2 | sed 's/[^"]*"\([^"]*\)"[^"]*/\1/g'`
#
ENDPOINT_IP=`ping -w1 -c1 $ENDPOINT | awk 'NR==1{gsub(/\(|\)/,"",$3);print $3}'`
echo $ENDPOINT_IP
# iptables stuffs
# run the port forwarding
echo "1" > /proc/sys/net/ipv4/ip_forward
/sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
/sbin/iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 6379 -j DNAT --to $ENDPOINT_IP:6379

