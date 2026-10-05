#!/usr/bin/env bash

theme="$HOME/.config/rofi/clipboard/clipboard.rasi"

# lancer rofi avec header propre
rofi_cmd() {
    rofi -dmenu \
        -p " Clipboard" \
        -theme "$theme"
}

# récupérer historique
selection=$(cliphist list | rofi_cmd)

# si sélection vide → exit
[ -z "$selection" ] && exit 0

# copier dans le presse-papier
echo "$selection" | cliphist decode | wl-copy
