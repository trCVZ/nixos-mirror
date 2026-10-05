#!/usr/bin/env bash

ICON_SUN=""
ICON_MOON=""
TEMP_NIGHT=4000
STATE_FILE="/tmp/hyprsunset_state"

get_state() {
    if pgrep -x hyprsunset >/dev/null; then
        echo "night"
    else
        echo "day"
    fi
}

toggle_mode() {
    local state
    state=$(get_state)
    if [ "$state" = "night" ]; then
        pkill -x hyprsunset
        echo "day" >"$STATE_FILE"
    else
        nohup hyprsunset --temperature "$TEMP_NIGHT" >/dev/null 2>&1 &
        echo "night" >"$STATE_FILE"
    fi
}

print_json() {
    local state icon
    state=$(get_state)
    if [ "$state" = "night" ]; then
        icon="$ICON_MOON"
    else
        icon="$ICON_SUN"
    fi
    echo "{\"text\": \"$icon\"}"
}

case "$1" in
toggle)
    toggle_mode
    ;;
start)
    toggle_mode
    ;;
*)
    print_json
    ;;
esac
