#!/bin/bash
# Module: vault-remote
# Description: Sincroniza secretos cifrados entre vault local y remoto
# License: GPLv3
# Author: Luis GuLo
# Version: 1.0
# Dependencies: ssh, scp, gpg

VAULT_DIR="core/vault"

vault_remote_task() {
  local host="$1"; shift
  declare -A args
  for arg in "$@"; do
    key="${arg%%=*}"
    value="${arg#*=}"
    args["$key"]="$value"
  done

  local action="${args[action]}"
  local key="${args[key]}"
  local remote_path="${args[remote_path]:-/tmp/bashflow_vault}"
  local become="${args[become]}"

  local prefix=""
  [ "$become" = "true" ] && prefix="sudo"

  case "$action" in
    push)
      if [ ! -f "$VAULT_DIR/$key.gpg" ]; then
        echo "  ❌ [vault-remote] Secreto '$key' no existe localmente."
        return 1
      fi
      scp "$VAULT_DIR/$key.gpg" "$host:$remote_path/$key.gpg"
      ssh "$host" "$prefix mkdir -p '$remote_path'"
      echo "📤 Secreto '$key' enviado a $host:$remote_path"
      ;;
    pull)
      ssh "$host" "$prefix test -f '$remote_path/$key.gpg'" || {
        echo "  ❌ [vault-remote] Secreto '$key' no existe en el host remoto."
        return 1
      }
      scp "$host:$remote_path/$key.gpg" "$VAULT_DIR/$key.gpg"
      echo "📥 Secreto '$key' recuperado desde $host"
      ;;
    sync)
      ssh "$host" "$prefix mkdir -p '$remote_path'"
      scp "$VAULT_DIR/"*.gpg "$host:$remote_path/"
      echo "🔄 Vault sincronizado con $host:$remote_path"
      ;;
    *)
      echo "  ❌ [vault-remote] Acción '$action' no soportada."
      return 1
      ;;
  esac
}

check_dependencies_vault_remote() {
  for cmd in ssh scp gpg; do
    if ! command -v "$cmd" &> /dev/null; then
      echo "  ❌ [vault-remote] $cmd no disponible."
      return 1
    fi
  done
  echo "  ✅ [vault-remote] Dependencias disponibles."
  return 0
}
