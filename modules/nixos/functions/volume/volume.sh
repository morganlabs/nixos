#!/usr/bin/env bash

if [[ -z "$1" ]]; then
    echo "Please choose an option."
    exit 1
fi

pamixer --unmute

CURRENT_VOLUME="$(pamixer --get-volume)"

round_down() {
    local number="$1"
    result=$((number / 5 * 5))
    echo $result
}

round_up() {
    local number="$1"
    result=$(( (number + 4) / 5 * 5 ))
    echo $result
}

case "$1" in
    inc)
        CURRENT_VOLUME="$(round_up "$CURRENT_VOLUME")"
        NEW_VOLUME="$((CURRENT_VOLUME + 5))"
    ;;
    dec)
        CURRENT_VOLUME="$(round_down "$CURRENT_VOLUME")"
        NEW_VOLUME="$((CURRENT_VOLUME - 5))"
    ;;
esac

pamixer --set-volume "$NEW_VOLUME"
