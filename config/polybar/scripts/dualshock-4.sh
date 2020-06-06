#!/bin/sh

#for i in /sys/class/power_supply/sony_controller_battery_*/capacity; do
#    echo "# $(cat /sys/class/power_supply/sony_controller_battery_"$i"/capacity)%"
#done
#if [[ $(cat /sys/class/power_supply/sony_controller_battery_a0:ab:51:3c:77:a8/capacity) ]]; then
if [[ $(ls /sys/class/power_supply) ]]; then
  echo "$(cat /sys/class/power_supply/sony_controller_battery_a0:ab:51:3c:77:a8/capacity)%"
else
  echo "disconnected"
fi
