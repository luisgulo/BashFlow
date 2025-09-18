#!/usr/bin/env bash
# Module: facts
# Description: Extrae información del sistema con opciones de formato, filtrado y salida
# License: GPLv3
# Author: Luis GuLo
# Version: 1.1
# Dependencies: lscpu, ip, free, lsblk, uname, hostnamectl

facts_task() {
  local host="$1"; shift
  declare -A args
  local field format output append host_label
  format="plain"
  append="false"

  for arg in "$@"; do
    key="${arg%%=*}"
    value="${arg#*=}"
    case "$key" in
      field) field="$value" ;;
      format) format="$value" ;;
      output) output="$value" ;;
      append) append="$value" ;;
      host_label) host_label="$value" ;;
    esac
  done

  local prefix=""
  [[ "$host" != "localhost" ]] && prefix="ssh $host"

  local raw
  raw=$($prefix bash <<'EOF'
    echo "hostname=$(hostname)"
    ip -o -4 addr show | awk '!/docker|virbr|lo/ {print $4}' | cut -d/ -f1 | paste -sd ',' - | sed 's/^/ip_addresses=/'
    ip link show | awk '/ether/ && !/docker/ {print $2}' | paste -sd ',' - | sed 's/^/mac_addresses=/'
    lscpu | awk '/^CPU\(s\):/ {print "cpu_count="$2}'
    free -m | awk '/Mem:/ {print "ram_total_mb="$2}'
    lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT | grep -Ev 'loop|tmpfs|overlay|docker' | awk 'NR>1 {print $0}' | paste -sd ';' - | sed 's/^/partitions=/'
    if command -v hostnamectl &> /dev/null; then
      hostnamectl | awk -F: '/Operating System/ {print "os_name=" $2}' | sed 's/^ *//'
      hostnamectl | awk -F: '/Kernel/ {print "os_version=" $2}' | sed 's/^ *//'
    else
      echo "os_name=$(uname -s)"
      echo "os_version=$(uname -r)"
    fi
EOF
)

  # Filtrado por campo
  if [[ -n "$field" ]]; then
    raw=$(echo "$raw" | grep "^$field=")
  fi

  # Formateo
  local formatted=""
  case "$format" in
    kv)
      formatted="$raw"
      ;;
    md)
      formatted=$(echo "$raw" | awk -F= '{printf "- **%s**: %s\n", $1, $2}')
      ;;
    plain)
      formatted=$(echo "$raw" | awk -F= '{printf "%s: %s\n", $1, $2}')
      ;;
    *)
      echo "❌ [facts] Formato '$format' no soportado."
      return 1
      ;;
  esac

  # Etiqueta de host
  [[ -n "$host_label" ]] && formatted="### $host_label\n$formatted"

  # Salida
  if [[ -n "$output" ]]; then
    if [[ "$append" == "true" ]]; then
      echo -e "$formatted" >> "$output"
    else
      echo -e "$formatted" > "$output"
    fi
    echo "💾 [facts] Informe guardado en: $output"
  else
    echo -e "$formatted"
  fi
}

check_dependencies_facts() {
  for cmd in lscpu ip free lsblk uname hostnamectl; do
    if ! command -v "$cmd" &> /dev/null; then
      echo "⚠️ [facts] '$cmd' no disponible localmente. Se asumirá que existe en el host remoto."
    else
      echo "✅ [facts] '$cmd' disponible localmente."
    fi
  done
  return 0
}
