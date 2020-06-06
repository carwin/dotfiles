#!/bin/bash

# headset="headset_head_unit"
# for i in {1..3}
# do
#   echo $(pacmd list-sinks | grep -e 'name:' -e 'index: 1')
# # pacmd list-sinks | grep -e 'name:' -e 'index:'
# done
sink=0

volume_up() {
  volume=$(pamixer --sink $sink --get-volume)
  if [ "$volume" -lt 100 ]; then
    pactl set-sink-volume $sink +1%
  fi
}

volume_down() {
  volume=$(pamixer --sink $sink --get-volume)
  if [ "$volume" -gt 0 ]; then
    pactl set-sink-volume $sink -1%
  fi
}

volume_mute() {
    pactl set-sink-mute $sink toggle
}

volume_print() {
    muted=$(pamixer --sink $sink --get-mute)

    if [ "$muted" = true ]; then
        echo " muted"
    else
        volume=$(pamixer --sink $sink --get-volume)

        if [ "$volume" -lt 50 ]; then
            echo " $volume %"
        else
            echo " $volume %"
        fi
    fi
}

listen() {
    volume_print

    pactl subscribe | while read -r event; do
        if echo "$event" | grep -q "#$sink"; then
            volume_print
        fi
    done
}

case "$1" in
    --up)
        volume_up
        ;;
    --down)
        volume_down
        ;;
    --mute)
        volume_mute
        ;;
    *)
        listen
        ;;
esac
