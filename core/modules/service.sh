#!/bin/bash
# Module: service
# Description: Controla servicios del sistema remoto (start, stop, restart, enable, disable) con idempotencia
# Author: Luis GuLo
# Version: 1.1
# Dependencies: ssh, systemctl
# Usage:
#   service_task "$host" "$name" "$action" "$become"

service_task() {
  local host="$1"
  local name="$2"
  local action="$3"
  local become="$4"

  local prefix=""
  [ "$become" = "true" ] && prefix="sudo"

  case "$action" in
    start)
      ssh "$host" "$prefix systemctl is-active --quiet $name || $prefix systemctl start $name"
      ;;
    stop)
      ssh "$host" "$prefix systemctl is-active --quiet $name && $prefix systemctl stop $name"
      ;;
    restart)
      ssh "$host" "$prefix systemctl restart $name"
      ;;
    enable)
      ssh "$host" "$prefix systemctl is-enabled --quiet $name || $prefix systemctl enable $name"
      ;;
    disable)
      ssh "$host" "$prefix systemctl is-enabled --quiet $name && $prefix systemctl disable $name"
      ;;
    *)
      echo "❌ [service] Acción '$action' no soportada."
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

