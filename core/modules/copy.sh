#!/bin/bash
# Module: copy
# Description: Copia archivos locales al host remoto usando scp
# License: GPLv3
# Author: Luis GuLo
# Version: 1.1
# Dependencies: scp, ssh

copy_task() {
  local host="$1"; shift
  declare -A args
  for arg in "$@"; do
    key="${arg%%=*}"
    value="${arg#*=}"
    args["$key"]="$value"
  done

  local src="${args[src]}"
  local dest="${args[dest]}"
  local mode="${args[mode]}"
  local become="${args[become]}"

  local prefix=""
  [ "$become" = "true" ] && prefix="sudo"

  # Copiar archivo temporalmente
  scp "$src" "$host:/tmp/bashflow_tmpfile" || return 1

  # Mover al destino final y aplicar permisos
  ssh "$host" "$prefix mv /tmp/bashflow_tmpfile '$dest' && $prefix chmod $mode '$dest'"
}

check_dependencies_copy() {
  local missing=0
  for cmd in scp ssh; do
    if ! command -v "$cmd" &> /dev/null; then
      echo "  ❌ [copy] $cmd no está disponible."
      missing=1
    else
      echo "  ✅ [copy] $cmd disponible."
    fi
  done
  return $missing
}
