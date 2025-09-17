#!/usr/bin/env bash
# Module: fs
# Description: Operaciones remotas sobre ficheros (mover, renombrar, copiar, borrar, truncar)
# License: GPLv3
# Author: Luis GuLo
# Version: 1.2
# Dependencies: ssh

fs_task() {
  local host="$1"; shift
  declare -A args
  local files=()

  # Parseo de argumentos
  for arg in "$@"; do
    key="${arg%%=*}"
    value="${arg#*=}"
    if [[ "$key" == "files" ]]; then
      # Detectar comodines
      if [[ "$value" == *'*'* || "$value" == *'?'* || "$value" == *'['* ]]; then
        mapfile -t files < <(ssh "$host" "ls -1 $value 2>/dev/null")
      else
        IFS=',' read -r -a files <<< "$value"
      fi
    else
      args["$key"]="$value"
    fi
  done

  local action="${args[action]}"
  local src="${args[src]}"
  local dest="${args[dest]}"
  local path="${args[path]}"
  local become="${args[become]}"
  local prefix=""
  [ "$become" = "true" ] && prefix="sudo"

  case "$action" in
    move|rename|copy)
      if [[ ${#files[@]} -gt 0 ]]; then
        for file in "${files[@]}"; do
          base="$(basename "$file")"
          target="$dest/$base"
          cmd="$prefix mv" && [[ "$action" == "copy" ]] && cmd="$prefix cp"
          ssh "$host" "$cmd '$file' '$target'" && echo "📁 [$action] $file → $target"
        done
      else
        cmd="$prefix mv" && [[ "$action" == "copy" ]] && cmd="$prefix cp"
        ssh "$host" "$cmd '$src' '$dest'" && echo "📁 [$action] $src → $dest"
      fi
      ;;
    delete|truncate)
      if [[ ${#files[@]} -gt 0 ]]; then
        for file in "${files[@]}"; do
          cmd="$prefix rm -f" && [[ "$action" == "truncate" ]] && cmd="$prefix truncate -s 0"
          ssh "$host" "$cmd '$file'" && echo "🧹 [$action] $file"
        done
      else
        cmd="$prefix rm -f" && [[ "$action" == "truncate" ]] && cmd="$prefix truncate -s 0"
        ssh "$host" "$cmd '$path'" && echo "🧹 [$action] $path"
      fi
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
