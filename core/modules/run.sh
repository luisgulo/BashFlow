#!/bin/bash
# Module: run
# Description: Ejecuta comandos remotos vía SSH, con soporte para vault y sudo
# Author: Luis GuLo
# Version: 1.1
# Dependencies: ssh, core/utils/vault_utils.sh

source "core/utils/vault_utils.sh"

run_task() {
  local host="$1"
  local command="$2"
  local become="$3"
  local vault_key="$4"   # Opcional: nombre de secreto en vault

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
    echo "❌ [run] ssh no está disponible."
    return 1
  fi
  echo "✅ [run] ssh disponible."
  return 0
}
