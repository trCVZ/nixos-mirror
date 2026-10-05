#!/usr/bin/env bash

declare -A params=(
  ["slab_nomerge"]="slab_nomerge"
  ["init_on_alloc"]="init_on_alloc=1"
  ["init_on_free"]="init_on_free=1"
  ["page_alloc.shuffle"]="page_alloc.shuffle=1"
  ["pti"]="pti=on"
  ["randomize_kstack_offset"]="randomize_kstack_offset=on"
  ["vsyscall"]="vsyscall=none"
  ["debugfs"]="debugfs=off"
  ["oops"]="oops=panic"
  ["module.sig_enforce"]="module.sig_enforce=1"
  ["lockdown"]="lockdown=confidentiality"
  ["mce"]="mce=0"
  ["quiet"]="quiet"
  ["loglevel"]="loglevel=0"
)

check_param() {
  local param="$1"
  local expected="$2"
  local current

  current=$(cat /proc/cmdline | tr ' ' '\n' | grep -w "^$param=")

  if [[ "$current" == "$expected" ]]; then
    echo -e "\033[32m[OK] $param=$expected\033[0m"
  else
    echo -e "\033[31m[KO] $param=$expected (actuel: $current)\033[0m"
  fi
}

for param in "${!params[@]}"; do
  check_param "$param" "${params[$param]}"
done

