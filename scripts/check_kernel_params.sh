#!/usr/bin/env bash

# Définir les paramètres souhaités
declare -A desired_values=(
  ["kernel.kptr_restrict"]="2"
  ["kernel.dmesg_restrict"]="1"
  ["kernel.printk"]="3 3 3 3"
  ["kernel.unprivileged_bpf_disabled"]="1"
  ["net.core.bpf_jit_harden"]="2"
  ["dev.tty.ldisc_autoload"]="0"
  ["vm.unprivileged_userfaultd"]="0"
  ["kernel.kexec_load_disabled"]="1"
  ["kernel.sysrq"]="0"
  ["kernel.unprivileged_usersn_clone"]="0"
  ["kernel.perf_event_paranoid"]="3"
  ["net.ipv4.tcp_syncookies"]="1"
  ["net.ipv4.tcp_rfc1337"]="1"
  ["net.ipv4.icmp_echo_ignore_all"]="1"
  ["net.ipv4.conf.all.rp_filter"]="1"
  ["net.ipv4.conf.default.rp_filter"]="1"
  ["net.ipv4.conf.all.accept_redirects"]="0"
  ["net.ipv4.conf.default.accept_redirects"]="0"
  ["net.ipv4.conf.all.secure_redirects"]="0"
  ["net.ipv4.conf.default.secure_redirects"]="0"
  ["net.ipv4.conf.all.send_redirects"]="0"
  ["net.ipv4.conf.default.send_redirects"]="0"
  ["net.ipv4.conf.all.log_martians"]="1"
  ["net.ipv4.conf.default.log_martians"]="1"
  ["net.ipv6.conf.all.accept_redirects"]="0"
  ["net.ipv6.conf.default.accept_redirects"]="0"
  ["net.ipv4.conf.all.accept_source_route"]="0"
  ["net.ipv4.conf.default.accept_source_route"]="0"
  ["net.ipv6.conf.all.accept_source_route"]="0"
  ["net.ipv6.conf.default.accept_source_route"]="0"
  ["net.ipv6.conf.all.accept_ra"]="0"
  ["net.ipv6.conf.default.accept_ra"]="0"
  ["net.ipv4.tcp_sack"]="0"
  ["net.ipv4.tcp_dsack"]="0"
  ["net.ipv4.tcp_fack"]="0"
  ["kernel.yama.ptrace_scope"]="2"
  ["vm.mmap_rnd_bits"]="32"
  ["vm.mmap_rnd_compat_bits"]="16"
  ["fs.protected_symlinks"]="1"
  ["fs.protected_hardlinks"]="1"
  ["fs.protected_fifos"]="2"
  ["fs.protected_regular"]="2"
  ["fs.suid_dumpable"]="0"
)

# Fonction pour afficher en couleur
print_color() {
  local color="$1"
  local message="$2"
  case "$color" in
    "green") echo -e "\e[32m$message\e[0m" ;;
    "red") echo -e "\e[31m$message\e[0m" ;;
    *) echo "$message" ;;
  esac
}

# Vérifier chaque paramètre
for param in "${!desired_values[@]}"; do
  current_value=$(sysctl -n "$param" 2>/dev/null)
  desired_value="${desired_values[$param]}"

  if [[ "$current_value" == "$desired_value" ]]; then
    print_color "green" "$param = $current_value (OK)"
  else
    print_color "red" "$param = $current_value (attendu: $desired_value)"
  fi
done

