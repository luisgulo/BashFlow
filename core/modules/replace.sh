#!/usr/bin/env bash
# Module: replace
# Description: Reemplaza texto en archivos usando expresiones regulares
# Author: Luis GuLo
# Version: 0.1
# Dependencies: sed, cp, tee

replace_task() {
  local host="$1"; shift
  declare -A args
  for arg in "$@"; do
    key="${arg%%=*}"
    value="${arg#*=}"
    args["$key"]="$value"
  done

  local path="${args[path]}"
  local regexp="${args[regexp]}"
  local replace="${args[replace]}"
  local backup="${args[backup]:-true}"
  local become="${args[become]}"

  local prefix=""
  [ "$become" = "true" ] && prefix="sudo"

  if [[ ! -f "$path" ]]; then
    echo "    ❌ [replace] El archivo no existe: $path"
    return 1
  fi

  if [[ "$backup" == "true" ]]; then
    cp "$path" "$path.bak"
    echo "📦 Copia de seguridad creada: $path.bak"
  fi

  $prefix sed -i "s|$regexp|$replace|g" "$path"
  echo "    ✅ [replace] Reemplazo aplicado en: $path"
}

check_dependencies_replace() {
  local missing=()
  for cmd in sed cp tee; do
    command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
    if [[ ${#missing[@]} -gt 0 ]]; then
      echo "    ❌ [replace] Dependencias faltantes: ${missing[*]}"
      return 1
    else
        echo "    ✅ [replace] $cmd disponible."
    fi
  done
}
