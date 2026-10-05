#!/usr/bin/env bash

shopt -s nullglob

dir="$HOME/002-Wallpapers/"

cwd="$(pwd)"
cd "$dir" || exit 1

IFS=$'\n'

selected=$(for a in *.jpg *.png; do 
    echo -en "$a\0icon\x1f$dir/$a\n"
done | rofi -dmenu -p "" -theme "~/.config/rofi/wallpaper/wallpaper.rasi")

if [ -n "$selected" ]; then
    hyprctl hyprpaper preload "$dir/$selected"
    hyprctl hyprpaper wallpaper "eDP-1,$dir/$selected"
    cp "$dir/$selected" ~/.config/hypr/wallpaper.jpg
fi

cd "$cwd"
