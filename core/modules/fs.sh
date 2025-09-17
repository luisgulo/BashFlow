#!/usr/bin/env bash
# Module: fs
# Description: Operaciones remotas sobre ficheros (mover, renombrar, copiar, borrar, truncar)
# License: GPLv3
# Author: Luis GuLo
# Version: 1.0
# Dependencies: ssh

fs_task() {
  local host="$1"; shift
  declare -A args
  for arg in "$@"; do
    key="${arg%%=*}"
    value="${arg#*=}"
    args["$key"]="$value"
  done

  local action="${args[action]}"
  local src="${args[src]}"
  local dest="${args[dest]}"
  local path="${args[path]}"
  local become="${args[become]}"
  local prefix=""
  [ "$become" = "true" ] && prefix="sudo"

  case "$action" in
    move)
      ssh "$host" "$prefix mv '$src' '$dest'" && echo "🚚 [fs] Fichero movido: $src → $dest"
      ;;
    rename)
      ssh "$host" "$prefix mv '$src' '$dest'" && echo "✏️ [fs] Fichero renombrado: $src → $dest"
      ;;
    copy)
      ssh "$host" "$prefix cp '$src' '$dest'" && echo "📄 [fs] Fichero copiado: $src → $dest"
      ;;
    delete)
      ssh "$host" "$prefix rm -f '$path'" && echo "🗑️ [fs] Fichero eliminado: $path"
      ;;
    truncate)
      ssh "$host" "$prefix truncate -s 0 '$path'" && echo "🧹 [fs] Fichero truncado: $path"
      ;;
    *)
      echo "❌ [fs] Acción '$action' no soportada."
      return 1
      ;;
  esac
}

check_dependencies_fs() {
  if ! command -v ssh &> /dev/null; then
    echo "❌ [fs] ssh no está disponible."
    return 1
  fi
  echo "✅ [fs] ssh disponible."
  return 0
}
