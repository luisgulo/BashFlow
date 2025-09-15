#!/bin/bash
# Module: service
# Description: Controla servicios del sistema remoto (start, stop, restart, enable, disable) con idempotencia
# Author: Luis GuLo
# Version: 1.1
# Dependencies: ssh, systemctl
# Usage:
#   service_task "$host" "$name" "$action" "$become"

service_task() {
  local host="$1"; shift
  declare -A args; for arg in "$@"; do key="${arg%%=*}"; value="${arg#*=}"; args["$key"]="$value"; done

  local name="${args[name]}"
  local state="${args[state]}"
  local become="${args[become]}"

  local prefix=""
  [ "$become" = "true" ] && prefix="sudo"

  case "$state" in
    start|stop|restart|enable|disable)
      ssh "$host" "$prefix systemctl $state '$name'"
      ;;
    *)
      echo "❌ [service] Estado '$state' no soportado."
      return 1
      ;;
  esac
}


check_dependencies_service() {
  if ! command -v ssh &> /dev/null; then
    echo "❌ [service] ssh no está disponible."
    return 1
  fi
  echo "✅ [service] ssh disponible."
  if ! command -v systemctl &> /dev/null; then
    echo "⚠️  [service] systemctl no está disponible localmente. Se asumirá que existe en el host remoto."
  else
    echo "✅ [service] systemctl disponible localmente."
  fi
  return 0
}

