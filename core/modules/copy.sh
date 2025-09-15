#!/bin/bash
# Module: copy
# Description: Copia archivos locales al host remoto usando scp
# Author: Luis GuLo
# Version: 1.0
# Dependencies: scp, ssh
# Usage:
#   copy_task "$host" "$src" "$dest" "$mode" "$become"

copy_task() {
  local host="$1"
  local src="$2"
  local dest="$3"
  local mode="$4"
  local become="$5"

  # Copiar archivo
  scp "$src" "$host:/tmp/bashflow_tmpfile" || return 1

  # Mover al destino final con permisos
  if [ "$become" = "true" ]; then
    ssh "$host" "sudo mv /tmp/bashflow_tmpfile '$dest' && sudo chmod $mode '$dest'"
  else
    ssh "$host" "mv /tmp/bashflow_tmpfile '$dest' && chmod $mode '$dest'"
  fi
}

check_dependencies_copy() {
  local missing=0
  for cmd in scp ssh; do
    if ! command -v "$cmd" &> /dev/null; then
      echo "❌ [copy] $cmd no está disponible."
      missing=1
    else
      echo "✅ [copy] $cmd disponible."
    fi
  done
  return $missing
}
