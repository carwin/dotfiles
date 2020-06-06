#!/bin/bash


# IP_ADDRESS=$(ip route get 1 | awk '{print $NF;exit}')

IP_ADDRESS=$(ip route get 8.8.8.8 | head -1 | cut -d' ' -f7)

if [[ "${IP_ADDRESS}" != "" ]]; then
  echo "${IP_ADDRESS}"
  echo "${IP_ADDRESS}"
  echo ""
fi

echo "${IP_ADDRESS}"

