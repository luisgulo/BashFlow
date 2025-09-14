#!/bin/bash
# Module: run
# Description: Ejecuta comandos remotos vía SSH
# Author: Luis GuLo
# Version: 1.0
# Dependencies: ssh
# Usage:
#   run_task "$host" "$command"

run_task() {
  local host="$1"
  local command="$2"
  ssh "$host" "$command"
}

check_dependencies_run() {
  if ! command -v ssh &> /dev/null; then
    echo "❌ [run] ssh no está disponible en el sistema."
    return 1
  fi
  echo "✅ [run] ssh disponible."
  return 0
}