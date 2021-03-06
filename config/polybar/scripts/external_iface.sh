#!/usr/bin/env bash

IP4=$(curl -s4 icanhazip.com)
IP6=$(curl -s6 icanhazip.com || echo "No IPv6")
PREV_FILE="/tmp/.icanhazip"

case $BLOCK_BUTTON in
    3) echo "$IP6" > "${PREV_FILE}" ;;
    2) cat "${PREV_FILE}" | xclip -c ;;
    *) echo "$IP4" > "${PREV_FILE}" ;;
esac

IP=$(cat "${PREV_FILE}")

echo "$IP"
echo "$IP"
echo ""
