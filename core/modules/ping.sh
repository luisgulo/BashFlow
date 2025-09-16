#!/bin/bash
# Module: ping
# Description: Verifica conectividad desde el host remoto hacia un destino específico
# License: GPLv3
# Author: Luis GuLo
# Version: 1.1
# Dependencies: ping, ssh

ping_task() {
  local host="$1"; shift
  declare -A args; for arg in "$@"; do key="${arg%%=*}"; value="${arg#*=}"; args["$key"]="$value"; done

  local count="${args[count]:-2}"       # Número de paquetes
  local timeout="${args[timeout]:-3}"   # Tiempo de espera en segundos
  local target="${args[target]:-127.0.0.1}"  # IP o dominio a hacer ping
  local become="${args[become]}"
  local prefix=""
  [ "$become" = "true" ] && prefix="sudo"

  echo "📡 [ping] Probando conectividad desde $host hacia $target..."

  ssh "$host" "$prefix ping -c $count -W $timeout $target &>/dev/null" \
    && echo "✅ [ping] $host puede alcanzar $target" \
    || echo "❌ [ping] $host no puede alcanzar $target"
}

check_dependencies_ping() {
  if ! command -v ssh &> /dev/null || ! command -v ping &> /dev/null; then
    echo "❌ [ping] ssh o ping no están disponibles."
    return 1
  fi
  echo "✅ [ping] ssh y ping disponibles."
  return 0
}
