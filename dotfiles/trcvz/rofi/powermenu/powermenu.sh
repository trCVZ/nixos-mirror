#!/usr/bin/env bash

theme_file="$HOME/.config/rofi/powermenu/powermenu.rasi"

uptime="$(awk -F'( |,|:)+' '{if ($7=="min") {print $6"m"} else if ($7=="days") {print $6"d "$8"h "$9"m"} else {print $6"h "$7"m"}}' <(uptime))"
host=$(hostname)

# Options avec icônes rofi
shutdown="⏻ Shutdown"
reboot=" Reboot"
lock=" Lock"
logout="󰍃 Logout"

yes=" Yes"
no=" No"

rofi_cmd() {
    rofi -dmenu \
        -p "$host" \
        -mesg "Uptime: $uptime" \
        -theme "$theme_file"
}

confirm_cmd() {
    rofi -dmenu \
        -p " Confirm" \
        -theme "$theme_file"
}

confirm_exit() {
    echo -e "$yes\n$no" | confirm_cmd
}

run_rofi() {
    echo -e "$lock\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

run_cmd() {
    selected="$(confirm_exit)"
    if [[ "$selected" == "$yes" ]]; then
        case $1 in
            --shutdown) systemctl poweroff ;;
            --reboot) systemctl reboot ;;
            --logout) loginctl terminate-user $USER ;;
        esac
    fi
}

chosen="$(run_rofi)"

case "$chosen" in
    "$shutdown") run_cmd --shutdown ;;
    "$reboot") run_cmd --reboot ;;
    "$lock") hyprlock ;;
    "$logout") run_cmd --logout ;;
esac
