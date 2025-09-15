#!/bin/bash
# Module: file
# Description: Gestiona archivos y directorios remotos (crear, eliminar, permisos)
# Author: Luis GuLo
# Version: 1.0
# Dependencies: ssh
# Usage:
#   file_task "$host" "$path" "$state" "$type" "$mode" "$become"

file_task() {
  local host="$1"
  local path="$2"
  local state="$3"     # present | absent
  local type="$4"      # file | directory
  local mode="$5"      # ej. 0644
  local become="$6"

  local prefix=""
  [ "$become" = "true" ] && prefix="sudo"

  case "$state" in
    present)
      if [ "$type" = "directory" ]; then
        ssh "$host" "[ -d '$path' ] || $prefix mkdir -p '$path'"
      elif [ "$type" = "file" ]; then
        ssh "$host" "[ -f '$path' ] || $prefix touch '$path'"
      fi
      [ -n "$mode" ] && ssh "$host" "$prefix chmod $mode '$path'"
      ;;
    absent)
      if [ "$type" = "directory" ]; then
        ssh "$host" "[ -d '$path' ] && $prefix rm -rf '$path'"
      elif [ "$type" = "file" ]; then
        ssh "$host" "[ -f '$path' ] && $prefix rm -f '$path'"
      fi
      ;;
    *)
      echo "❌ [file] Estado '$state' no soportado."
      return 1
      ;;
  esac
}

check_dependencies_file() {
  if ! command -v ssh &> /dev/null; then
    echo "❌ [file] ssh no está disponible."
    return 1
  fi
  echo "✅ [file] ssh disponible."
  return 0
}
