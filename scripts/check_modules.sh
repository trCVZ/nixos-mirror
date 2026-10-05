#!/usr/bin/env bash

declare -A expected_install=(
  [dccp]="/bin/false"
  [sctp]="/bin/false"
  [rds]="/bin/false"
  [tipc]="/bin/false"
  [n_hdlc]="/bin/false"
  [ax25]="/bin/false"
  [netrom]="/bin/false"
  [x25]="/bin/false"
  [rose]="/bin/false"
  [decnet]="/bin/false"
  [econet]="/bin/false"
  [af_802154]="/bin/false"
  [ipx]="/bin/false"
  [appletalk]="/bin/false"
  [psnap]="/bin/false"
  [p8023]="/bin/false"
  [p8022]="/bin/false"
  [can]="/bin/false"
  [atm]="/bin/false"
  [cramfs]="/bin/false"
  [freevxfs]="/bin/false"
  [jffs2]="/bin/false"
  [hfs]="/bin/false"
  [hfsplus]="/bin/false"
  [squashfs]="/bin/false"
  [udf]="/bin/false"
  [cifs]="/bin/true"
  [nfs]="/bin/true"
  [nfsv3]="/bin/true"
  [nfsv4]="/bin/true"
  [ksmbd]="/bin/true"
  [gfs2]="/bin/true"
  [vivid]="/bin/false"
  [uvcvideo]="/bin/false"
  [overlay]="/bin/false"
  [firewire-core]="/bin/false"
  [usb-storage]="/bin/false"
)

mods=(
  dccp sctp rds tipc n_hdlc ax25 netrom x25 rose decnet econet af_802154
  ipx appletalk psnap p8023 p8022 can atm
  cramfs freevxfs jffs2 hfs hfsplus squashfs udf
  cifs nfs nfsv3 nfsv4 ksmbd gfs2
  vivid uvcvideo
  overlay firewire-core usb-storage
)

for m in "${mods[@]}"; do
  expected="${expected_install[$m]}"

  if modinfo "$m" >/dev/null 2>&1; then
    present="yes"
  else
    present="no"
  fi

  if lsmod | awk '{print $1}' | grep -qx "$m"; then
    loaded="yes"
  else
    loaded="no"
  fi

  probe_line="$(modprobe -n -v "$m" 2>/dev/null | head -n1)"
  if [[ "$probe_line" == *"$expected"* ]]; then
    policy_ok="yes"
  else
    policy_ok="no"
  fi

  printf "%-12s present=%-3s loaded=%-3s expected=%-10s policy_ok=%-3s\n" \
    "$m" "$present" "$loaded" "$expected" "$policy_ok"
done