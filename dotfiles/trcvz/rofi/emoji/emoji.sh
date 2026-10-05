#!/usr/bin/env bash

theme="$HOME/.config/rofi/emoji/emoji.rasi"

rofimoji \
  --selector rofi \
  --selector-args "-theme $theme -i" \
  --clipboarder wl-copy \
  --max-recent 20
