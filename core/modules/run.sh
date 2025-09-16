#!/bin/bash
# Module: run
# Description: Ejecuta comandos remotos vía SSH, con soporte para vault y sudo
# License: GPLv3
# Author: Luis GuLo
# Version: 1.1
# Dependencies: ssh, core/utils/vault_utils.sh

# Detectar raíz del proyecto si no está definida
PROJECT_ROOT="${BASHFLOW_HOME:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"

# Cargar utilidades
source "$PROJECT_ROOT/core/utils/vault_utils.sh"

run_task() {
  local host="$1"; shift
  declare -A args; for arg in "$@"; do key="${arg%%=*}"; value="${arg#*=}"; args["$key"]="$value"; done

  local command="${args[command]}"
  local become="${args[become]}"
  local vault_key="${args[vault_key]}"

  local prefix=""
  [ "$become" = "true" ] && prefix="sudo"

  if [ -n "$vault_key" ]; then
    local secret
    secret=$(get_secret "$vault_key") || return 1
    ssh "$host" "$prefix TOKEN='$secret' $command"
  else
    ssh "$host" "$prefix $command"
  fi
}

check_dependencies_run() {
  if ! command -v ssh &> /dev/null; then
    echo "  ❌ [run] ssh no está disponible."
    return 1
  fi
  echo "  ✅ [run] ssh disponible."
  return 0
}
