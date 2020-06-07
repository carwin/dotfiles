#!/bin/sh

TOKEN="2424073d9adb42b67174759f4fc15bc8fe9df9d5"

notifications=$(curl -fs https://api.github.com/notifications?access_token=$TOKEN | jq ".[].unread" | grep -c true)

if [ "$notifications" -gt 0 ]; then
    echo " $notifications"
else
    echo ""
fi
