#!/usr/bin/env bash
# Module: facts
# Description: Extrae información del sistema con opciones de formato, filtrado y salida
# License: GPLv3
# Author: Luis GuLo
# Version: 1.3.2

facts_task() {
  local host="$1"; shift
  declare -A args
  local field format output append host_label
  format="plain"
  append="false"

  # 🧩 Parseo de argumentos
  for arg in "$@"; do
    key="${arg%%=*}"
    value="${arg#*=}"
    case "$key" in
      field) field="$value" ;;
      format) format="${value,,}" ;;
      output) output="$value" ;;
      append) append="$value" ;;
      host_label) host_label="$value" ;;
    esac
  done

  # 🛡️ Validación defensiva
  if [[ -z "$host_label" ]]; then
    host_label="$host"
  fi

  [[ "$DEBUG" == "true" ]] && echo "🔍 [facts] host_label='$host_label' format='$format' output='$output'"

  local prefix=""
  [[ "$host" != "localhost" ]] && prefix="ssh $host"
  

  [[ "$DEBUG" == "true" ]] && echo "🔍 Línea SSH: $prefix bash --noprofile --norc"
  [[ "$DEBUG" == "true" ]] && echo "🔍 Ejecutando bloque remoto en $host..."

  local raw
  #raw=$($prefix bash <<'EOF'
  raw=$($prefix bash --noprofile --norc <<'EOF'
    cd /tmp || cd ~
    echo "hostname=$(hostname)"
    lscpu | awk '/^CPU\(s\):/ {print "cpu_count="$2}'
    free -m | awk '/Mem:/ {print "ram_total_mb="$2}'
    if command -v hostnamectl &> /dev/null; then
      hostnamectl | awk -F: '/Operating System/ {print "os_name=" $2}' | sed 's/^ *//'
      hostnamectl | awk -F: '/Kernel/ {print "os_version=" $2}' | sed 's/^ *//'
    else
      echo "os_name=$(uname -s)"
      echo "os_version=$(uname -r)"
    fi

    ip link show | awk -F: '/^[0-9]+: / {print $2}' | grep -Ev 'docker|virbr|lo|veth|br-' | while read -r dev; do
      ip=$(ip -4 addr show "$dev" | awk '/inet / {print $2}' | cut -d/ -f1)
      mac=$(ip link show "$dev" | awk '/ether/ {print $2}')
      [[ -n "$ip" || -n "$mac" ]] && echo "net_$dev=IP:$ip MAC:$mac"
    done

    lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT | grep -Ev 'loop|tmpfs|overlay|docker' | awk 'NR>1 && NF>0 {print "partition_list=" $1 " " $2 " " $3 " " $4}'
EOF
)

  [[ -n "$field" ]] && raw=$(echo "$raw" | grep "^$field=")

  local partitions=()
  local facts=()
  while IFS= read -r line; do
    if [[ "$line" == partition_list=* ]]; then
      partitions+=("${line#*=}")
    else
      facts+=("$line")
    fi
  done <<< "$raw"

  local formatted=""
  case "$format" in
    plain)
      formatted+="Host: $host_label\n"
      for f in "${facts[@]}"; do
        key="${f%%=*}"; val="${f#*=}"
        formatted+="$key: $val\n"
      done
      if [[ ${#partitions[@]} -gt 0 ]]; then
        formatted+="partitions:\n"
        for p in "${partitions[@]}"; do
          formatted+="  - $p\n"
        done
      fi
      ;;
    md)
      formatted+="### $host_label\n"
      for f in "${facts[@]}"; do
        key="${f%%=*}"; val="${f#*=}"
        formatted+="- **$key:** $val\n"
      done
      if [[ ${#partitions[@]} -gt 0 ]]; then
        formatted+="- **partitions:**\n"
        for p in "${partitions[@]}"; do
          formatted+="  - $p\n"
        done
      fi
      ;;
    kv)
      for f in "${facts[@]}"; do
        formatted+="$f\n"
      done
      if [[ ${#partitions[@]} -gt 0 ]]; then
        formatted+="partitions=$(IFS=';'; echo "${partitions[*]}")\n"
      fi
      ;;
    json)
      local json="{"
      for f in "${facts[@]}"; do
        key="${f%%=*}"; val="${f#*=}"
        json+="\"$key\":\"$val\","
      done
      if [[ ${#partitions[@]} -gt 0 ]]; then
        json+="\"partitions\":["
        for p in "${partitions[@]}"; do
          json+="\"$p\","
        done
        json="${json%,}]"  # cerrar array
      else
        json="${json%,}"   # quitar coma final
      fi
      json+="}"
      formatted="$json"
      ;;
    *)
      echo "❌ [facts] Formato '$format' no soportado."
      return 1
      ;;
  esac

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
      echo "    ⚠️ [facts] '$cmd' no disponible localmente. Se asumirá que existe en el host remoto."
    else
      echo "    ✅ [facts] '$cmd' disponible localmente."
    fi
  done
  return 0
}
