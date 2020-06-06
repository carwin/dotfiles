#!/bin/bash

DIR="/var/run/vpnc/defaultroute"

# IF VPN is running
if [ -a $DIR ]; then
  STATUS=$(ssh 10.16.1.251 curl -s http://192.168.100.1/cgi-bin/status)
else
  STATUS=$(curl -s http://192.168.100.1/cgi-bin/status)
fi

if [ -z "$STATUS" ]; then
  exit
fi

UN=$(echo "$STATUS" |  pup 'form center:nth-of-type(1) tr:not(:nth-of-type(2)) td:nth-last-of-type(1) json{}' | jq  -r '.[].text' | jq -s add)
C=$(echo "$STATUS" |  pup 'form center:nth-of-type(1) tr:not(:nth-of-type(2)) td:nth-last-of-type(2) json{}' | jq  -r '.[].text' | jq -s add)


# C = Correctables, UN = Uncorrectables
echo "C:$C U:$UN"
echo "C:$C U:$UN"
if [ "$UN" -gt 0 ]; then
  echo "#FF0000"
fi
